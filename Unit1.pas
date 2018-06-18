unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Math, ShellAPI;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    Label6: TLabel;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Generate;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TRGB = array [1..3] of Byte;
  TBytesArray = array of Byte;
  TMatrix = array [-30..+30, -30..+30] of SmallInt;
  TBooleanArray = array [0..5000, 0..3500] of Boolean;
  TBooleanMatrix = array [-30..+30, -30..+30] of Boolean;
  TRGBArray = array [0..5000, 0..3500] of TRGB;
  TPnt = array [1..2] of TPoint;

var
  Form1: TForm1;
  Bytes: TBytesArray;
  nBytes, A, B, I: Integer;
  Matrix: TMatrix;
  Sum: Int64;
  BooleanMatrix: TBooleanMatrix;
  Pixels: TRGBArray;
  Mark: array [0..3000, 0..2000] of Boolean;
  Index: Word;

const
  Words: array [1..48] of string = ('کتـاب', 'زبـان', 'عـرفان', 'معـرفت', 'خـانگی', 'مواظبت', 'کارگـر', 'گلخانه', 'سرسبز', 'اشکال', 'موضوع', 'مالیات', 'باقی', 'خـانواده', 'فـردوسی', 'تهـران', 'هـرگز', 'همیشگی', 'حـامی', 'خمیدگی', 'نمـاز', 'گوینـده', 'گواهی', 'عینک', 'کاغذ', 'پزشک', 'مـادر', 'خواهـر', 'مسخره', 'مشهـد',
'مطهر', 'مصطفی', 'مشترک', 'مستخدم', 'مخمـل', 'محمود', 'محجوب', 'مجموعه', 'محـرم', 'مجهز', 'محاصره', 'مبالغه', 'مبهوت', 'متحیر', 'متخصص', 'ایرانی', 'تشخیص', 'رضـا');

implementation

{$R *.dfm}

function ATan(xx, yy: Real): Real;
var
	xxx, yyy, Teta: Real;
begin
	xxx := Abs(xx);
  yyy := Abs(yy);
  if (xx >= 0) and (yy >= 0) and (xxx > yyy) then Teta := ArcTan(yyy / xxx);
  if (xx >= 0) and (yy >= 0) and (xxx < yyy) then Teta := Pi /2 - ArcTan(xxx / yyy);
  if (xx >= 0) and (yy >= 0) and (xxx = yyy) then Teta := Pi / 4;
	if (xx <  0) and (yy >= 0) and (xxx > yyy) then Teta := Pi - ArcTan(yyy / xxx);
  if (xx <  0) and (yy >= 0) and (xxx < yyy) then Teta := Pi /2 + ArcTan(xxx / yyy);
  if (xx <  0) and (yy >= 0) and (xxx = yyy) then Teta := Pi - Pi / 4;
	if (xx <  0) and (yy <  0) and (xxx > yyy) then Teta := Pi + ArcTan(yyy / xxx);
  if (xx <  0) and (yy <  0) and (xxx < yyy) then Teta := 3 * Pi / 2 - ArcTan(xxx / yyy);
	if (xx <  0) and (yy <  0) and (xxx = yyy) then Teta := Pi + Pi / 4;
  if (xx >= 0) and (yy <  0) and (xxx > yyy) then Teta := 2 * Pi - ArcTan(yyy / xxx);
	if (xx >= 0) and (yy <  0) and (xxx < yyy) then Teta := 3 * Pi / 2 + ArcTan(xxx / yyy);
  if (xx >= 0) and (yy <  0) and (xxx = yyy) then Teta := 2 * Pi - Pi / 4;
  ATan := Teta;
end;

function Dis (X1, Y1, X2, Y2: Int64): Extended;
begin
  Dis := Sqrt ((X1 - X2) * (X1 - X2) + (Y1 - Y2) * (Y1 - Y2));
end;

procedure Swap(var A, B: TColor);
var
  C: TColor;
begin
  C := A;
  A := B;
  B := C;
end;

function ColorToRGB (Color: TColor): TRGB;
begin
  Result[1] := GetRValue (Color);
  Result[2] := GetGValue (Color);
  Result[3] := GetBValue (Color);
end;

function BytesPerPixel(APixelFormat: TPixelFormat): Integer;
begin
  Result := -1;
  case APixelFormat of
    pf8bit: Result := 1;
    pf16bit: Result := 2;
    pf24bit: Result := 3;
    pf32bit: Result := 4;
  end;
end;

procedure BitmapToBytes(Bitmap: TBitmap; out Bytes: TBytesArray; var nBytes : Longint);
var
  BytesPerLine: Integer;
  Row, BPP: Integer;
  PPixels : Pointer;
  PBytes : ^TBytesArray;
begin
  BPP := BytesPerPixel(Bitmap.PixelFormat);
  if BPP < 1 then
    raise Exception.Create('Unknown pixel format');
  nBytes := Bitmap.Width * Bitmap.Height * BPP;
  SetLength(Bytes, nBytes);
  BytesPerLine := Bitmap.Width * BPP;
  for Row := 0 to Bitmap.Height-1 do
  begin
    PBytes := @Bytes[Row * BytesPerLine];
    PPixels := Bitmap.ScanLine[Row];
    CopyMemory(PBytes, PPixels, BytesPerLine);
  end;
end;

procedure BytesToBitmap(const Bytes: TBytesArray; Bitmap: TBitmap;
  APixelFormat: TPixelFormat; AWidth, AHeight: Integer);
var
  BytesPerLine: Integer;
  Row, BPP: Integer;
  PPixels, PBytes : Pointer;
begin
  BPP := BytesPerPixel(APixelFormat);
  if BPP < 1 then
    raise Exception.Create('Unknown pixel format');
  if (AWidth * AHeight * BPP) <> Length(Bytes) then
    raise Exception.Create('Bytes do not match image properties');
  Bitmap.Width := AWidth;
  Bitmap.Height := AHeight;
  Bitmap.PixelFormat := APixelFormat;
  BytesPerLine := Bitmap.Width * BPP;
  for Row := 0 to Bitmap.Height-1 do
  begin
    PBytes := @Bytes[Row * BytesPerLine];
    PPixels := Bitmap.ScanLine[Row];
    CopyMemory(PPixels, PBytes, BytesPerLine);
  end;
end;

function BlurMatrixX (Value: Word): TMatrix;
var
  I: Integer;
begin
  if Value <> 0 then
    for I := -Value to +Value do
      Result[0, I] := Value - Abs (I);
end;

function BlurMatrixY (Value: Word): TMatrix;
var
  I: Integer;
begin
  if Value <> 0 then
    for I := -Value to +Value do
      Result[I, 0] := Value - Abs (I);
end;

function BlurMatrix (Radius: TPoint): TMatrix;
var
  M: Real;
  X, Y: Integer;
begin
  M := Max (Radius.X, Radius.Y);
  Matrix := BlurMatrixX (Radius.X);
  Matrix := BlurMatrixY (Radius.Y);
  Sum := 0;
  for X := -Radius.X to +Radius.X do
    for Y := -Radius.Y to +Radius.Y do
    begin
      if Dis (X, Y, 0, 0) <= M then
      begin
        Result[X, Y] := Matrix[X, 0] * Matrix[0, Y];
        Sum := Sum + Result[X, Y];
      end
      else
        Result[X, Y] := 0;
    end;
end;

function BlurMatrix2 (Radius: TPoint): TMatrix;
var
  X, Y: Integer;
begin
  Matrix := BlurMatrixX (Radius.X);
  Matrix := BlurMatrixY (Radius.Y);
  Result := Matrix;
  Sum := 0;
  for X := -Radius.X to +Radius.X do
    for Y := -Radius.Y to +Radius.Y do
      if (X = 0) or (Y = 0) then
        Sum := Sum + Matrix[X, Y];
end;

function MotionBlurMatrix (Radius: TPoint; Angle: Real): TMatrix;
var
  X, Y, I: Integer;
begin
  Angle := DegToRad (Angle);
  for X := -Radius.X to +Radius.X do
    for Y := -Radius.Y to +Radius.Y do
      Result[X, Y] := 0;
  for I := 0 to Round (Max (Radius.X, Radius.Y)) do
  begin
    X := Round (Cos (Angle) * I);
    Y := Round (Sin (Angle) * I);
    Result[X, Y] := 1;
    Result[-X, -Y] := 1;
  end;
  Sum := 0;
  for X := -Radius.X to +Radius.X do
    for Y := -Radius.Y to +Radius.Y do
      Inc (Sum, Result[X, Y]);
end;

function MotionBlurMatrix2 (Radius: TPoint; Angle: Real): TMatrix;
var
  X, Y, I: Integer;
begin
  Angle := DegToRad (Angle);
  for X := -Radius.X to +Radius.X do
    for Y := -Radius.Y to +Radius.Y do
      Result[X, Y] := 0;
  for I := 0 to Round (Max (Radius.X, Radius.Y)) do
  begin
    X := Round (Cos (Angle) * I);
    Y := Round (Sin (Angle) * I);
    Result[X, Y] := 1;
  end;
  Sum := 0;
  for X := -Radius.X to +Radius.X do
    for Y := -Radius.Y to +Radius.Y do
      Inc (Sum, Result[X, Y]);
end;

procedure GBlur(Image1: TImage; var Image2: TImage; Matrix: TMatrix; Radius: TPoint; Divisor: Real);
var
  R, G, B, D: Int64;
  X, Y, X2, Y2: Integer;
  Bytes2: TBytesArray;
begin
  Image2.Picture := Image1.Picture;
  BitmapToBytes(Image1.Picture.Bitmap, Bytes, nBytes);
  Bytes2 := Bytes;
  for X := 0 to Image1.Picture.Width - 1 do
    for Y := 0 to Image1.Picture.Height - 1 do
    begin
      R := 0;
      G := 0;
      B := 0;
      D := 0;
      for X2 := X - Radius.X to X + Radius.X do
        for Y2 := Y - Radius.Y to Y + Radius.Y do
        begin
          if (X2 < 0) or (X2 > Image1.Picture.Width - 1) or (Y2 < 0) or (Y2 > Image1.Picture.Height - 1) then
          begin
            Inc (D, Matrix[X2 - X, Y2 - Y]);
          end
          else
          begin
            R := R + Matrix[X2 - X, Y2 - Y] * Bytes2[3 * (Y2 * Image1.Picture.Width + X2) + 2];
            G := G + Matrix[X2 - X, Y2 - Y] * Bytes2[3 * (Y2 * Image1.Picture.Width + X2) + 1];
            B := B + Matrix[X2 - X, Y2 - Y] * Bytes2[3 * (Y2 * Image1.Picture.Width + X2) + 0];
          end;
        end;
      begin
        R := Round (R / (Divisor - D));
        G := Round (G / (Divisor - D));
        B := Round (B / (Divisor - D));
      end;
      Bytes[3 * (Y * Image1.Picture.Width + X) + 2] := R;
      Bytes[3 * (Y * Image1.Picture.Width + X) + 1] := G;
      Bytes[3 * (Y * Image1.Picture.Width + X) + 0] := B;
    end;
  BytesToBitmap(Bytes, Image2.Picture.Bitmap, Image1.Picture.Bitmap.PixelFormat, Image1.Picture.Bitmap.Width, Image1.Picture.Bitmap.Height);
end;

function MatrixToBooleanMatrix (Matrix: TMatrix; Radius: TPoint): TBooleanMatrix;
var
  X, Y: SmallInt;
begin
  for X := -Radius.X to +Radius.X do
    for Y := -Radius.Y to +Radius.Y do
      Result[X, Y] := Matrix[X, Y] = 1;
end;

procedure MotionBlur (Image1: TImage; var Image2: TImage; Matrix: TMatrix; Radius: TPoint; Divisor: Real);
var
  R, G, B, D: Int64;
  X, Y, X2, Y2: Integer;
begin
  Image2.Picture := Image1.Picture;
  BooleanMatrix := MatrixToBooleanMatrix (Matrix, Radius);
  for X := 0 to Image1.Picture.Width - 1 do
    for Y := 0 to Image1.Picture.Height - 1 do
      Pixels[X, Y] := ColorToRGB (Image1.Picture.Bitmap.Canvas.Pixels[X, Y]);
  for X := 0 to Image1.Picture.Width - 1 do
    for Y := 0 to Image1.Picture.Height - 1 do
    begin
      R := 0;
      G := 0;
      B := 0;
      D := 0;
      for X2 := X - Radius.X to X + Radius.X do
        for Y2 := Y - Radius.Y to Y + Radius.Y do
        begin
          if BooleanMatrix[X2 - X, Y2 - Y] then
          begin
            if (X2 < 0) or (X2 > Image1.Picture.Width - 1) or (Y2 < 0) or (Y2 > Image1.Picture.Height - 1) then
              Inc (D)
            else
            begin
              R := R + Pixels[X2, Y2, 1];
              G := G + Pixels[X2, Y2, 2];
              B := B + Pixels[X2, Y2, 3];
            end;
          end;
        end;
      Image2.Picture.Bitmap.Canvas.Pixels[X, Y] := RGB (Round (R / (Divisor - D)), Round (G / (Divisor - D)), Round (B / (Divisor - D)));
    end;
end;

procedure TrimImage(var Image: TImage);
var
  X, Y, MinX, MinY, MaxX, MaxY, Rx, Ry: Integer;
  Pixel: TColor;
begin
  MinX := Image.Width - 1;
  MinY := Image.Height - 1;
  MaxX := 0;
  MaxY := 0;
  for X := 0 to Image.Width - 1 do
    for Y := 0 to Image.Height - 1 do
    begin
      Pixel := Image.Canvas.Pixels[X, Y];
      if (GetRValue(Pixel) < 220) and (GetGValue(Pixel) < 220) and (GetBValue(Pixel) < 220) then
      //if Image.Canvas.Pixels[X, Y] <> clWhite then
      begin
        if X < MinX then
          MinX := X;
        if Y < MinY then
          MinY := Y;
        if X > MaxX then
          MaxX := X;
        if Y > MaxY then
          MaxY := Y;
      end;
    end;
  Rx := Random(16) + 10;
  Ry := Random(16) + 10;
  Dec(MinX, Rx);
  Dec(MinY, Ry);
  for X := 0 to Image.Width - 1 do
    for Y := 0 to Image.Height - 1 do
    begin
      if (X in [0..Image.Width - MinX - 1]) and (Y in [0..Image.Height - MinY - 1]) then
        Image.Canvas.Pixels[X, Y] := Image.Canvas.Pixels[X + MinX, Y + MinY]
      else
        Image.Canvas.Pixels[X, Y] := clWhite;
    end;
  Rx := Random(16) + 10;
  Ry := Random(16) + 10;
  Image.Width := (MaxX - MinX) + Rx;
  Image.Height := (MaxY - MinY) + Ry;
end;

procedure Noise (Image1: TImage; var Image2: TImage; Value: Integer; Monochromatic: Byte);
const
  Color: array [0..1, 1..3] of TColor = ((clRed , clGreen, clBlue), (clGray, clGray, clGray));
var
  R2, G2, B2: Byte;
  R1, G1, B1: Word;
  X, Y, Value2: Integer;
  Pixel1, Pixel2: TColor;
begin
  Image2.Picture := Image1.Picture;
  for X := 0 to Image1.Picture.Width - 1 do
    for Y := 0 to Image1.Picture.Height - 1 do
    begin
      Pixel1 := Color[MonoChromatic, Random (3) + 1];
      Pixel2 := Image1.Picture.Bitmap.Canvas.Pixels[X, Y];
      R1 := GetRValue (Pixel1);
      G1 := GetGValue (Pixel1);
      B1 := GetBValue (Pixel1);
      R2 := GetRValue (Pixel2);
      G2 := GetGValue (Pixel2);
      B2 := GetBValue (Pixel2);
      Value2 := Random (Value + 1);
      R1 := Round (Value2 / 100 * R1 + (100 - Value2) / 100 * R2);
      G1 := Round (Value2 / 100 * G1 + (100 - Value2) / 100 * G2);
      B1 := Round (Value2 / 100 * B1 + (100 - Value2) / 100 * B2);
      if R1 > 255 then
        R1 := 255;
      if G1 > 255 then
        G1 := 255;
      if B1 > 255 then
        B1 := 255;
      if not((GetRValue(Pixel2) <= 120) and (GetGValue(Pixel2) <= 120) and (GetBValue(Pixel2) <= 120)) then
      begin
        if (R1 <= 120) and (B1 <= 120) and (G1 <= 120) then
        begin
          R1 := 121;
          G1 := 121;
          B1 := 121;
        end;
      end;
      Image2.Picture.Bitmap.Canvas.Pixels[X, Y] := RGB (R1, G1, B1);
    end;
end;

procedure Disorganize (var Image: TImage; Value: Integer);
var
  X, Y, X2, Y2: Integer;
  P1, P2: TColor;
begin
  for X := 0 to Image.Width - 1 do
    for Y := 0 to Image.Height - 1 do
    begin
      if Random(2) = 0 then
        if Image.Canvas.Pixels[X, Y] <> clWhite then
        begin
          repeat
            X2 := Random (Value * 2 + 1);
            Y2 := Random (Value * 2 + 1);
          until (X - Value + X2 >= 0) and (X - Value + X2 < Image.Width) and (Y - Value + Y2 >= 0) and (Y - Value + Y2 < Image.Height);
          P1 := Image.Canvas.Pixels[X, Y];
          P2 := Image.Canvas.Pixels[X - Value + X2, Y - Value + Y2];
          Swap(P1, P2);
          Image.Canvas.Pixels[X, Y] := P1;
          Image.Canvas.Pixels[X - Value + X2, Y - Value + Y2] := P2;
        end;
    end;
end;

procedure DrawLines(var Image: TImage; Count: Word);
var
  I, X, Y: Word;
begin
  for I := 1 to Count do
  begin
    Image.Canvas.Pen.Color := RGB(Random(26) + 200, Random(26) + 200, Random(26) + 200);
    X := Random(Image.Width);
    Y := Random(Image.Height);
    Image.Canvas.MoveTo(X, Y);
    Image.Canvas.LineTo(X + Random(33) - 16, Y + Random(33) - 16);
  end;
end;

var
  X2, Y2: ShortInt;
  Pixel: TColor;

procedure FindPoints (var PaintBox: TImage; X, Y: Word; BorderColor: TColor; var Points: TPnt);
begin
  //PaintBox.Canvas.Pixels[X, Y] := Color;
  Mark[X, Y] := False;
  if Points[1].X > X then
    Points[1].X := X;
  if Points[1].Y > Y then
    Points[1].Y := Y;
  if Points[2].X < X then
    Points[2].X := X;
  if Points[2].Y < Y then
    Points[2].Y := Y;
  for X2 := -1 to +1 do
    for Y2 := -1 to +1 do
      if (X + X2 >= 0) and (Y + Y2 >= 0) and (X + X2 < PaintBox.Width) and (Y + Y2 < PaintBox.Height) then
        if (Abs (X2) <> Abs (Y2)) or (X2 = 0) then
        begin
          Pixel := PaintBox.Picture.Bitmap.Canvas.Pixels[X + X2, Y + Y2];
          if (Mark[X + X2, Y + Y2]) and (Pixel > RGB(150, 150, 150)) and (Pixel <> BorderColor) then
            FindPoints (PaintBox, X + X2, Y + Y2, BorderColor, Points);
        end;
end;

procedure FindPoints2 (var PaintBox: TImage; X, Y: Word; BackColor: TColor; var Points: TPnt);
var
  X2, Y2: Integer;
begin
  //PaintBox.Canvas.Pixels[X, Y] := Color;
  Mark[X, Y] := False;
  if Points[1].X > X then
    Points[1].X := X;
  if Points[1].Y > Y then
    Points[1].Y := Y;
  if Points[2].X < X then
    Points[2].X := X;
  if Points[2].Y < Y then
    Points[2].Y := Y;
  for X2 := -1 to +1 do
    for Y2 := -1 to +1 do
      //if (X + X2 >= 0) and (Y + Y2 >= 0) and (X + X2 < PaintBox.Width) and (Y + Y2 < PaintBox.Height) then
        if (Abs (X2) <> Abs (Y2)) or (X2 = 0) then
          if (Mark[X + X2, Y + Y2]) and (PaintBox.Picture.Bitmap.Canvas.Pixels[X + X2, Y + Y2] = BackColor) then
            FindPoints (PaintBox, X + X2, Y + Y2, BackColor, Points);
end;

procedure FillGradient (var PaintBox: TImage; X, Y: Integer; Color1, Color2: TColor{; BorderColor: TColor});
var
  Pnt: TPnt;
  //I, J: Integer;
begin
  {for I := 0 to 3000 do
    for J := 0 to 2000 do
      Mark[I, J] := True;}
  //Pnt[1] := Point (PaintBox.Width - 1, PaintBox.Height - 1);
  //FindPoints (PaintBox, X, Y, BorderColor, Pnt);
  Pnt[1] := Point(0, 0);
  Pnt[2] := Point(PaintBox.Width - 1, PaintBox.Height - 1);
  X := Pnt[1].X;
  while X <= Pnt[2].X do
  begin
    for Y := Pnt[1].Y to Pnt[2].Y do
    begin
      Pixel := PaintBox.Picture.Bitmap.Canvas.Pixels[X, Y];
      //if not Mark[I, J] then
      if Pixel > RGB(150, 150, 150) then
        PaintBox.Picture.Bitmap.Canvas.Pixels[X, Y] := RGB (Round ((GetRValue (Color1) + (X - Pnt[1].X) * (GetRValue (Color2) - GetRValue (Color1)) / (Pnt[2].X - Pnt[1].X) + GetRValue(Pixel)) / 2),
                                                            Round ((GetGValue (Color1) + (X - Pnt[1].X) * (GetGValue (Color2) - GetGValue (Color1)) / (Pnt[2].X - Pnt[1].X) + GetGValue(Pixel)) / 2),
                                                            Round ((GetBValue (Color1) + (X - Pnt[1].X) * (GetBValue (Color2) - GetBValue (Color1)) / (Pnt[2].X - Pnt[1].X) + GetBValue(Pixel)) / 2));
    end;
    X := X + 1;
  end;
end;

procedure FillCircularGradient (var PaintBox: TImage; X, Y: Integer; Color1, Color2: TColor{; BorderColor: TColor});
var
  Pnt: TPnt;
  {I, J, }R, G, B: Integer;
begin
  {for I := 0 to 3000 do
    for J := 0 to 2000 do
      Mark[I, J] := True;
  Pnt[1] := Point (PaintBox.Width - 1, PaintBox.Height - 1);
  FindPoints (PaintBox, X, Y, BorderColor, Pnt);}
  Pnt[1] := Point(0, 0);
  Pnt[2] := Point(PaintBox.Width - 1, PaintBox.Height - 1);
  X := Pnt[1].X;
  X2 := Random(PaintBox.Width + Random(81) - 40);
  Y2 := Random(PaintBox.Height + Random(81) - 40);
  while X <= Pnt[2].X do
  begin
    for Y := Pnt[1].Y to Pnt[2].Y do
    begin
      Pixel := PaintBox.Picture.Bitmap.Canvas.Pixels[X, Y];
      //if not Mark[I, J] then
      if Pixel > RGB(105, 105, 105) then
      begin
        R := Round ((GetRValue (Color1) + Dis (X, Y, X2, Y2) * (GetRValue (Color2) - GetRValue (Color1)) / Dis (0, 0, X2, Y2)) / 2 + GetRValue(Pixel) / 2);
        G := Round ((GetGValue (Color1) + Dis (X, Y, X2, Y2) * (GetGValue (Color2) - GetGValue (Color1)) / Dis (0, 0, X2, Y2)) / 2 + GetGValue(Pixel) / 2);
        B := Round ((GetBValue (Color1) + Dis (X, Y, X2, Y2) * (GetBValue (Color2) - GetBValue (Color1)) / Dis (0, 0, X2, Y2)) / 2 + GetBValue(Pixel) / 2);
        PaintBox.Picture.Bitmap.Canvas.Pixels[X, Y] := RGB(Max(Min(R, 255), 0), Max(Min(G, 255), 0), Max(Min(B, 255), 0));
      end
      else
      begin
        R := Round ((GetRValue (Color1) + Dis (X, Y, X2, Y2) * (GetRValue (Color2) - GetRValue (Color1)) / Dis (0, 0, X2, Y2)) / 2 + GetRValue(Pixel) / 2) - 12;
        G := Round ((GetGValue (Color1) + Dis (X, Y, X2, Y2) * (GetGValue (Color2) - GetGValue (Color1)) / Dis (0, 0, X2, Y2)) / 2 + GetGValue(Pixel) / 2) - 12;
        B := Round ((GetBValue (Color1) + Dis (X, Y, X2, Y2) * (GetBValue (Color2) - GetBValue (Color1)) / Dis (0, 0, X2, Y2)) / 2 + GetBValue(Pixel) / 2) - 12;
        PaintBox.Picture.Bitmap.Canvas.Pixels[X, Y] := RGB(Max(Min(R, 255), 0), Max(Min(G, 255), 0), Max(Min(B, 255), 0));
      end;
    end;
    X := X + 1;
  end;
end;

procedure FillGradient2 (var PaintBox: TImage; X, Y: Integer; Color1, Color2: TColor; BackColor: TColor);
var
  Pnt: TPnt;
  I, J: Integer;
begin
  for I := 0 to 1500 do
    for J := 0 to 1000 do
      Mark[I, J] := True;
  Pnt[1] := Point (PaintBox.Width - 1, PaintBox.Height - 1);
  FindPoints2 (PaintBox, X, Y, BackColor, Pnt);
  X := Pnt[1].X;
  while X <= Pnt[2].X do
  begin
    for Y := Pnt[1].Y to Pnt[2].Y do
    begin
      I := X;
      J := Y;
      if not Mark[I, J] then
        PaintBox.Canvas.Pixels[X, Y] := RGB (Round (GetRValue (Color1) + (X - Pnt[1].X) * (GetRValue (Color2) - GetRValue (Color1)) / (Pnt[2].X - Pnt[1].X)),
                                             Round (GetGValue (Color1) + (X - Pnt[1].X) * (GetGValue (Color2) - GetGValue (Color1)) / (Pnt[2].X - Pnt[1].X)),
                                             Round (GetBValue (Color1) + (X - Pnt[1].X) * (GetBValue (Color2) - GetBValue (Color1)) / (Pnt[2].X - Pnt[1].X)));
    end;
    X := X + 1;
  end;
end;

function EmbossMatrix (Radius: TPoint; Angle: Real): TMatrix;
var
  X, Y: Integer;
begin
  Sum := 1;
  Angle := DegToRad (Angle);
  for X := -Radius.X to +Radius.X do
    for Y := -Radius.Y to +Radius.Y do
    begin
      if X = 0 then
        Matrix[X, Y] := 0;
      if X < 0 then
        Matrix[X, Y] := -1;
      if X > 0 then
        Matrix[X, Y] := 1;
    end;
  for X := -Radius.X to +Radius.X do
    for Y := -Radius.Y to +Radius.Y do
      Result[X, Y] := Matrix[Round (Cos (ATan (X, Y) + Angle) * Dis (X, Y, 0, 0)), Round (Sin (ATan (X, Y) + Angle) * Dis (X, Y, 0, 0))];
end;

procedure Emboss (Image1: TImage; var Image2: TImage; Matrix: TMatrix; Radius: TPoint);
var
  K: Byte;
  R, G, B: Int64;
  X, Y, X2, Y2: Integer;
begin
  Image2.Picture := Image1.Picture;
  for X := 0 to Image1.Picture.Width - 1 do
    for Y := 0 to Image1.Picture.Height - 1 do
      Pixels[X, Y] := ColorToRGB (Image1.Picture.Bitmap.Canvas.Pixels[X, Y]);
  for X := 0 to Image1.Picture.Width - 1 do
    for Y := 0 to Image1.Picture.Height - 1 do
    begin
      R := 0;
      G := 0;
      B := 0;
      for X2 := X - Radius.X to X + Radius.X do
        for Y2 := Y - Radius.Y to Y + Radius.Y do
        begin
          if (X2 < 0) or (X2 > Image1.Picture.Width - 1) or (Y2 < 0) or (Y2 > Image1.Picture.Height - 1) then
          begin
            R := R + Matrix[X2 - X, Y2 - Y] * Pixels[X, Y, 1];
            G := G + Matrix[X2 - X, Y2 - Y] * Pixels[X, Y, 2];
            B := B + Matrix[X2 - X, Y2 - Y] * Pixels[X, Y, 3];
          end
          else
          begin
            R := R + Matrix[X2 - X, Y2 - Y] * Pixels[X2, Y2, 1];
            G := G + Matrix[X2 - X, Y2 - Y] * Pixels[X2, Y2, 2];
            B := B + Matrix[X2 - X, Y2 - Y] * Pixels[X2, Y2, 3];
          end;
        end;
      Inc (R, 128);
      Inc (G, 128);
      Inc (B, 128);
      if R < 0 then
        R := 0;
      if G < 0 then
        G := 0;
      if B < 0 then
        B := 0;
      if R > 255 then
        R := 255;
      if G > 255 then
        G := 255;
      if B > 255 then
        B := 255;
      K := Min (R, Min (G, B));
      Image2.Picture.Bitmap.Canvas.Pixels[X, Y] := RGB (K, K, K);
    end;
end;

procedure TForm1.Generate;
begin
  Randomize;
  Image1.Width := 260;
  Image1.Height := 260;
  Image1.Canvas.Brush.Color := clWhite;
  Image1.Canvas.FillRect(Rect(0, 0, 259, 259));
  //A := Random(6);
  Image1.Canvas.Font := Label1.Font;
  Index := Random(48) + 1;
  {case A of
    0: Image1.Canvas.Font := Label1.Font;
    1: Image1.Canvas.Font := Label1.Font;
    2: Image1.Canvas.Font := Label2.Font;
    3: Image1.Canvas.Font := Label3.Font;
    4: Image1.Canvas.Font := Label4.Font;
    5: Image1.Canvas.Font := Label5.Font;
  end;}
  Image1.Canvas.Font.Size := Random(8) + 24;
  Image1.Canvas.Font.Orientation := Random(531) + 70;
  Image1.Canvas.Font.Color := RGB(Random(46), Random(46), Random(46));
  Image1.Canvas.TextOut(20, 155, Words[Index]);
  B := Random(3);
  //Matrix := EmbossMatrix(Point(1, 1) , 0);
  //Emboss(Image1, Image1, Matrix, Point(1, 1));
  if B = 0 then
  begin
    A := 5;
    Matrix := BlurMatrix(Point(A, A));
    Image1.Picture.Bitmap.PixelFormat := pf24bit;
    GBlur(Image1, Image1, Matrix, Point(A, A), Sum);
  end;
  if B = 1 then
  begin
    A := 3;
    Matrix := MotionBlurMatrix(Point(A, A), Random(360));
    MotionBlur(Image1, Image1, Matrix, Point (A, A), Sum);
  end;
  if B = 2 then
    Disorganize(Image1, 2);
  TrimImage(Image1);
  FillCircularGradient(Image1, 5, 5, RGB(Random(256), Random(256), Random(256)), RGB(Random(256), Random(256), Random(256)));
  Noise(Image1, Image1, Random(14) + 12, Random(2));
  DrawLines(Image1, Random(14) + 5);
end;

function NastaliqToNormal(S: string): string;
begin
  for I := 1 to Length(S) do
    if S[I] = 'ـ' then
      Delete(S, I, 1);
  Result := S;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  TrimImage(Image1);
  if Edit1.Text = NastaliqToNormal(Words[Index]) then
  begin
    Label6.Font.Color := clGreen;
    Label6.Caption := 'Correct';
  end
  else
  begin
    Label6.Font.Color := clRed;
    Label6.Caption := 'Wrong';
  end;
  Edit1.Text := '';
  Generate;
  Edit1.SetFocus;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Generate;
  Edit1.SetFocus;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ShowMessage('For the first time use, install Nastaliq font. If you''ve already installed it, replace it with your current font.');
  ShellExecute(Handle, 'Preview', 'C:\Nastaliq.ttf', '', nil, SW_SHOW);
  Generate;
end;

end.
