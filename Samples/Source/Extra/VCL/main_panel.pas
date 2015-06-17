unit main_panel;

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
Uses TERRA_Utils, TERRA_Application, TERRA_VCLApplication, TERRA_OS, TERRA_Scene, TERRA_Texture,
  TERRA_Viewport, TERRA_FileManager, TERRA_SpriteManager, TERRA_PNG,
  TERRA_GraphicsManager, TERRA_Math, TERRA_Vector2D, TERRA_Color;

{$R *.dfm}

Type
  MyScene = Class(Scene)
    Procedure RenderSprites(V:Viewport); Override;
  End;

Var
  _Tex:Texture = Nil;
  _Scene:MyScene;
  _ExtraView:Viewport;

{ MyScene }
Procedure MyScene.RenderSprites(V: Viewport);
Var
  S:QuadSprite;
  Angle:Single;
Begin
  // A rotating sprite in the bottom, with Scale = 4x
  Angle := RAD * ((Application.GetTime() Div 15) Mod 360);
  S := SpriteManager.Instance.DrawSprite(100, 100, 50, _Tex);
  S.SetScaleAndRotationRelative(VectorCreate2D(0.5, 0.5), 4.0, Angle);  // Calculate rotation, in degrees, from current time
End;

Procedure TForm1.FormCreate(Sender: TObject);
Begin
  VCLApplication.Create(Panel1);

  // Added Asset folder to search path
  FileManager.Instance.AddPath('assets');

  // Load a Tex
  _Tex := TextureManager.Instance['ghost'];

  // Create a scene and set it as the current scene
  _Scene := MyScene.Create;
  GraphicsManager.Instance.SetScene(_Scene);

  // set background color
  GraphicsManager.Instance.ActiveViewport.BackgroundColor := ColorGreen;

{  _ExtraView := Viewport.Create('extra1', Image1.Width, Image1.Height);
  _ExtraView.OffScreen := True;
  _ExtraView.BackgroundColor := ColorRed;
  _ExtraView.Active := True;
  GraphicsManager.Instance.AddViewport(_ExtraView);
  MyClient.AddViewport(VCLCanvasViewport.Create(_ExtraView, Image1.Canvas));}
End;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  ReleaseObject(_Scene);
  Application.Instance.Terminate();
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  If OpenDialog1.Execute Then
    _Tex := Texture.LoadFromFile(OpenDialog1.FileName);
end;

end.
