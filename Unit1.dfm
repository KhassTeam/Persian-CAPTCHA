object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Persian CAPTCHA'
  ClientHeight = 253
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 70
    Top = 8
    Width = 211
    Height = 151
  end
  object Label1: TLabel
    Left = 0
    Top = 8
    Width = 97
    Height = 25
    AutoSize = False
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'IranNastaliq'
    Font.Orientation = 999
    Font.Pitch = fpVariable
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label2: TLabel
    Left = 8
    Top = 39
    Width = 97
    Height = 25
    AutoSize = False
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'B Yekan'
    Font.Orientation = 999
    Font.Pitch = fpVariable
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label3: TLabel
    Left = 8
    Top = 70
    Width = 97
    Height = 25
    AutoSize = False
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'B Nazanin'
    Font.Orientation = 999
    Font.Pitch = fpVariable
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object Label4: TLabel
    Left = 8
    Top = 101
    Width = 97
    Height = 25
    AutoSize = False
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'B Mehr'
    Font.Orientation = 999
    Font.Pitch = fpVariable
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label5: TLabel
    Left = 8
    Top = 132
    Width = 97
    Height = 25
    AutoSize = False
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'B Titr'
    Font.Orientation = 999
    Font.Pitch = fpVariable
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label6: TLabel
    Left = 181
    Top = 195
    Width = 5
    Height = 19
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 16
    Top = 196
    Width = 105
    Height = 21
    Hint = 'Enter the recognized word here'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 30
    Top = 223
    Width = 75
    Height = 25
    Caption = 'Submit'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 166
    Top = 223
    Width = 75
    Height = 25
    Caption = 'Regenerate'
    TabOrder = 2
    OnClick = Button2Click
  end
end
