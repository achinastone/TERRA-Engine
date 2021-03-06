Unit TERRA_UIImage;

{$I terra.inc}

Interface
Uses TERRA_Object, TERRA_String, TERRA_Utils, TERRA_UIWidget, TERRA_Color,
  TERRA_UIDimension, TERRA_Sprite, TERRA_Texture, TERRA_Renderer, TERRA_Vector2D, TERRA_Viewport;

Type
  UIImage = Class(UIWidget)
  private
    function GetU1: Single;
    function GetU2: Single;
    function GetV1: Single;
    function GetV2: Single;
    procedure SetU1(const Value: Single);
    procedure SetU2(const Value: Single);
    procedure SetV1(const Value: Single);
    procedure SetV2(const Value: Single);
    Protected
      _Texture:TextureProperty;
      _Stretch:BooleanProperty;
      _U1, _V1, _U2, _V2:FloatProperty;


      Function GetTexture: TERRATexture;

      Procedure UpdateSprite(); Override;

      Class Function GetObjectType:TERRAString; Override;

    Public
      Anchor:Vector2D;
      Flip, Mirror:Boolean;
      Filter:TextureFilterMode;

      Constructor Create(Name:TERRAString; Parent:UIWidget; Const X,Y:UIDimension; Const Layer:Single; Const Width, Height:UIDimension);

      Procedure SetTexture(Tex:TERRATexture);

      Property Texture:TERRATexture Read GetTexture Write SetTexture;

      Property U1:Single Read GetU1 Write SetU1;
      Property V1:Single Read GetV1 Write SetV1;
      Property U2:Single Read GetU2 Write SetU2;
      Property V2:Single Read GetV2 Write SetV2;

  End;


Implementation
Uses TERRA_Log, TERRA_Engine, TERRA_DebugDraw;

{ UIImage }
Constructor UIImage.Create(Name:TERRAString; Parent:UIWidget; Const X,Y:UIDimension; Const Layer:Single; Const Width, Height:UIDimension);
Begin
  Inherited Create(Name, Parent);

  Self.Left := X;
  Self.Top := Y;
  Self.Layer := Layer;
  Self.Filter := filterLinear;

  Self._Texture := TextureProperty(Self.AddProperty(TextureProperty.Create('image', Nil), False));
  _Stretch := BooleanProperty(Self.AddProperty(BooleanProperty.Create('stretch', False), False));
  _U1 := FloatProperty(Self.AddProperty(FloatProperty.Create('u1', 0), False));
  _V1 := FloatProperty(Self.AddProperty(FloatProperty.Create('v1', 0), False));
  _U2 := FloatProperty(Self.AddProperty(FloatProperty.Create('u2', 1), False));
  _V2 := FloatProperty(Self.AddProperty(FloatProperty.Create('v2', 1), False));

  Self.Width := Width;
  Self.Height := Height;

  Self.Pivot := Vector2D_Create(0, 0);
  Self.Anchor := Vector2D_Create(0, 0);
End;


Class Function UIImage.GetObjectType: TERRAString;
Begin
  Result := 'UIImage';
End;

Function UIImage.GetTexture: TERRATexture;
Begin
  Result := _Texture.Value;
End;

Function UIImage.GetU1: Single;
Begin
  Result := _U1.Value;
End;

Function UIImage.GetU2: Single;
Begin
  Result := _U2.Value;
End;

Function UIImage.GetV1: Single;
Begin
  Result := _V1.Value;
End;

Function UIImage.GetV2: Single;
Begin
  Result := _V2.Value;
End;

Procedure UIImage.SetTexture(Tex: TERRATexture);
Begin
  If Tex = Nil Then
    Tex := Engine.Textures.WhiteTexture
  Else
    Tex.Prefetch();

  _Texture.Value := Tex;
End;

procedure UIImage.SetU1(const Value: Single);
begin

end;

procedure UIImage.SetU2(const Value: Single);
begin

end;

procedure UIImage.SetV1(const Value: Single);
begin

end;

procedure UIImage.SetV2(const Value: Single);
begin

end;

Procedure UIImage.UpdateSprite();
Begin
  If (_Stretch.Value) Or (Self.Texture = Nil) Then
    _FullSize := CurrentSize
  Else
    _FullSize := Vector2D_Create(Self.Texture.Width, Self.Texture.Height);

  If (Self.Width.Value<=0) And (Assigned(Texture)) Then
    Self.Width := UIPixels(Trunc(SafeDiv(Texture.Width, Texture.Ratio.X)));

  If (Self.Height.Value<=0) And (Assigned(Texture)) Then
    Self.Height := UIPixels(Trunc(SafeDiv(Texture.Height, Texture.Ratio.Y)));


  If _Sprite = Nil Then
    _Sprite := TERRASprite.Create()
  Else
    _Sprite.Clear();

  _Sprite.Texture := Self.Texture;

  _Sprite.Layer := Self.GetLayer();
  _Sprite.Saturation := Self.GetSaturation();
  _Sprite.Glow := Self.GetGlow();

  If Texture=Nil Then
    Texture := Engine.Textures.WhiteTexture;
  Texture.Filter := Filter;

  _Sprite.Flip := Self.Flip;
  _Sprite.Mirror := Self.Mirror;
  _Sprite.SetUVs(_U1.Value, _V1.Value, _U2.Value, _V2.Value);
  _Sprite.SetColor(Self.Color);
  _Sprite.AddQuad(spriteAnchor_TopLeft, Vector2D_Create(0,0), 0.0, _FullSize.X, _FullSize.Y);

  _Sprite.ClipRect := Self.ClipRect;
  _Sprite.SetTransform(_Transform);
End;

End.