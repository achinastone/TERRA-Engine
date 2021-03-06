{$I terra.inc}
{$IFDEF MOBILE}Library{$ELSE}Program{$ENDIF} MaterialDemo;

uses
  MemCheck,
  TERRA_Object,
  TERRA_MemoryManager,
  TERRA_Application,
  TERRA_DemoApplication,
  TERRA_Engine,
  TERRA_Utils,
  TERRA_ResourceManager,
  TERRA_GraphicsManager,
  TERRA_Renderer,
  TERRA_OS,
  TERRA_Vector2D,
  TERRA_Font,
  TERRA_Texture,
  TERRA_FileManager,
  TERRA_InputManager,
  TERRA_Collections,
  TERRA_Viewport,
  TERRA_TTF,
  TERRA_PNG,
  TERRA_Math,
  TERRA_Color,
  TERRA_String,
  TERRA_ScreenFX,
  TERRA_Matrix4x4,
  TERRA_UIView,
  TERRA_UIWidget,
  TERRA_UITemplates,
  TERRA_UIImage,
  TERRA_UITiledRect,
  TERRA_UIDimension;

Type
  MyDemo = Class(DemoApplication)
    Public
			Procedure OnCreate; Override;

      Procedure OnMyButtonClick(Src:UIWidget);
  End;

Var
  MyWnd, MyBtn:UIWidget;

{ Game }
Procedure MyDemo.OnCreate;
Begin
  Inherited;

  Self.GUI.Viewport.FXChain.AddEffect(GlowFX.Create());
  Self.GUI.Viewport.FXChain.AddEffect(VignetteFX.Create());
  //Self.Scene.GUI.Viewport.FXChain.AddEffect(BloomFX.Create());


  UITemplates.AddTemplate(UIWindowTemplate.Create('wnd_template', Engine.Textures.GetItem('ui_window'), 45, 28, 147, 98));
  UITemplates.AddTemplate(UIButtonTemplate.Create('btn_template', Engine.Textures.GetItem('ui_button2'), 25, 10, 220, 37));

  MyWnd := UIInstancedWidget.Create('mywnd', Self.GUI, UIPixels(0), UIPixels(0), 10, UIPixels(643), UIPixels(231), 'wnd_template');
  MyWnd.Draggable := True;
  MyWnd.Align := UIAlign_Center;
//  MyWnd.Rotation := 45*RAD;

  MyBtn := UIInstancedWidget.Create('mybtn', MyWnd, UIPixels(0), UIPixels(0), 1, UIPixels(250), UIPixels(50), 'btn_template');
  MyBtn.Align := UIAlign_Center;
  MyBtn.SetEventHandler(widgetEvent_MouseDown, Self.OnMyButtonClick);

//  MyBtn.Draggable := True;

//  MyBtn.SetPropertyValue('caption', 'custom caption!');
//  MyBtn.Rotation := 45*RAD;
End;

Procedure MyDemo.OnMyButtonClick(Src:UIWidget);
Begin
  Src.Hide();
 // MyUI.MessageBox('You clicked the button!');
End;


{$IFDEF IPHONE}
Procedure StartGame; cdecl; export;
{$ENDIF}
Begin
  MyDemo.Create();
{$IFDEF IPHONE}
End;
{$ENDIF}

End.

