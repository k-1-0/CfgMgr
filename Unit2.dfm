object ProfileForm: TProfileForm
  Left = 490
  Top = 182
  BorderStyle = bsDialog
  ClientHeight = 563
  ClientWidth = 484
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 48
    Width = 98
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Profile DB directory:'
  end
  object Label2: TLabel
    Left = 9
    Top = 76
    Width = 98
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Target config:'
  end
  object Label3: TLabel
    Left = 9
    Top = 20
    Width = 98
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Profile name:'
  end
  object Label5: TLabel
    Left = 24
    Top = 289
    Width = 180
    Height = 13
    Caption = 'Delete files before launch application:'
  end
  object Label6: TLabel
    Left = 252
    Top = 289
    Width = 173
    Height = 13
    Caption = 'Delete files after ending application:'
  end
  object SpeedButton2: TSpeedButton
    Left = 440
    Top = 44
    Width = 23
    Height = 20
    Hint = 'Select...'
    Flat = True
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1896CE1092CE
      1896CE1896CE1896CE1896CE1896CE1896CE1896CE1092CE1896CE1092CE1896
      CEFF00FFFF00FFFF00FF1092CE1096CEBDEFF794E7F763DFF763DFF763DFF763
      DFF763DFF763DFF763DFF739BEE71896CEFF00FFFF00FFFF00FF1896CE29AED6
      94D7EFDEF7F763DFF763DFF763DFF763DFF763DFF763DFF76BE3FF63DFF7219E
      D61896CEFF00FFFF00FF1086BD6BDBF729A2D6F7FFFFC6EFF76BDFEF6BDFEF6B
      DFEF6BDFEF6BDFEF6BDFEF6BDFEF4ABEDE2996C61896CEFF00FF108ABD6BDBF7
      39B6E7D6F7F7FFFFFFD6F3F7D6F3F7D6F3F7D6F3F7D6F3F7D6F3F7D6F3F7D6F3
      F742AACE1896CEFF00FF1092CEADE3E75ACFDE73C7E7F7FFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF63DBE71896CEFF00FF1896CECEFBF7
      73F3FF39AECE1896CE1092CE1896CE1092CE1896CE1092CE108ABD1086BD1896
      CE1092CEFF00FFFF00FF1092CEEFFFFF73F3FF73F3FF73F3FF73F3FF73EFFF73
      EFFF73EFFF73EFFF6BEBF763DBE71086BDFF00FFFF00FFFF00FF1896CEFFFFFF
      7BF7FF73F7F773F7F77BF7FF7BF7FF73F3F77BF3FF7BF3FF7BF3FF63DBE7108A
      BDFF00FFFF00FFFF00FF1092CEFFFFFF7BF7FF7BFBFF7BF7FF7BF7FF7BF7FF7B
      F7FF7BF7FF7BF7FF7BF7FF63DBE71096CEFF00FFFF00FFFF00FF1896CEFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF63DBE71096
      CEFF00FFFF00FFFF00FF1086BD1096CE1092CE1096CE1092CE1096CE1096CE10
      96CE1096CE1096CE1096CE1096CE1096CEFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    ParentShowHint = False
    ShowHint = True
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 440
    Top = 72
    Width = 23
    Height = 20
    Hint = 'Select...'
    Flat = True
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1896CE1092CE
      1896CE1896CE1896CE1896CE1896CE1896CE1896CE1092CE1896CE1092CE1896
      CEFF00FFFF00FFFF00FF1092CE1096CEBDEFF794E7F763DFF763DFF763DFF763
      DFF763DFF763DFF763DFF739BEE71896CEFF00FFFF00FFFF00FF1896CE29AED6
      94D7EFDEF7F763DFF763DFF763DFF763DFF763DFF763DFF76BE3FF63DFF7219E
      D61896CEFF00FFFF00FF1086BD6BDBF729A2D6F7FFFFC6EFF76BDFEF6BDFEF6B
      DFEF6BDFEF6BDFEF6BDFEF6BDFEF4ABEDE2996C61896CEFF00FF108ABD6BDBF7
      39B6E7D6F7F7FFFFFFD6F3F7D6F3F7D6F3F7D6F3F7D6F3F7D6F3F7D6F3F7D6F3
      F742AACE1896CEFF00FF1092CEADE3E75ACFDE73C7E7F7FFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF63DBE71896CEFF00FF1896CECEFBF7
      73F3FF39AECE1896CE1092CE1896CE1092CE1896CE1092CE108ABD1086BD1896
      CE1092CEFF00FFFF00FF1092CEEFFFFF73F3FF73F3FF73F3FF73F3FF73EFFF73
      EFFF73EFFF73EFFF6BEBF763DBE71086BDFF00FFFF00FFFF00FF1896CEFFFFFF
      7BF7FF73F7F773F7F77BF7FF7BF7FF73F3F77BF3FF7BF3FF7BF3FF63DBE7108A
      BDFF00FFFF00FFFF00FF1092CEFFFFFF7BF7FF7BFBFF7BF7FF7BF7FF7BF7FF7B
      F7FF7BF7FF7BF7FF7BF7FF63DBE71096CEFF00FFFF00FFFF00FF1896CEFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF63DBE71096
      CEFF00FFFF00FFFF00FF1086BD1096CE1092CE1096CE1092CE1096CE1096CE10
      96CE1096CE1096CE1096CE1096CE1096CEFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    ParentShowHint = False
    ShowHint = True
    OnClick = SpeedButton3Click
  end
  object SpeedButton4: TSpeedButton
    Left = 440
    Top = 229
    Width = 23
    Height = 20
    Hint = 'Select...'
    Flat = True
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1896CE1092CE
      1896CE1896CE1896CE1896CE1896CE1896CE1896CE1092CE1896CE1092CE1896
      CEFF00FFFF00FFFF00FF1092CE1096CEBDEFF794E7F763DFF763DFF763DFF763
      DFF763DFF763DFF763DFF739BEE71896CEFF00FFFF00FFFF00FF1896CE29AED6
      94D7EFDEF7F763DFF763DFF763DFF763DFF763DFF763DFF76BE3FF63DFF7219E
      D61896CEFF00FFFF00FF1086BD6BDBF729A2D6F7FFFFC6EFF76BDFEF6BDFEF6B
      DFEF6BDFEF6BDFEF6BDFEF6BDFEF4ABEDE2996C61896CEFF00FF108ABD6BDBF7
      39B6E7D6F7F7FFFFFFD6F3F7D6F3F7D6F3F7D6F3F7D6F3F7D6F3F7D6F3F7D6F3
      F742AACE1896CEFF00FF1092CEADE3E75ACFDE73C7E7F7FFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF63DBE71896CEFF00FF1896CECEFBF7
      73F3FF39AECE1896CE1092CE1896CE1092CE1896CE1092CE108ABD1086BD1896
      CE1092CEFF00FFFF00FF1092CEEFFFFF73F3FF73F3FF73F3FF73F3FF73EFFF73
      EFFF73EFFF73EFFF6BEBF763DBE71086BDFF00FFFF00FFFF00FF1896CEFFFFFF
      7BF7FF73F7F773F7F77BF7FF7BF7FF73F3F77BF3FF7BF3FF7BF3FF63DBE7108A
      BDFF00FFFF00FFFF00FF1092CEFFFFFF7BF7FF7BFBFF7BF7FF7BF7FF7BF7FF7B
      F7FF7BF7FF7BF7FF7BF7FF63DBE71096CEFF00FFFF00FFFF00FF1896CEFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF63DBE71096
      CEFF00FFFF00FFFF00FF1086BD1096CE1092CE1096CE1092CE1096CE1096CE10
      96CE1096CE1096CE1096CE1096CE1096CEFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    ParentShowHint = False
    ShowHint = True
    OnClick = SpeedButton4Click
  end
  object Label7: TLabel
    Left = 12
    Top = 261
    Width = 87
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Arguments:'
  end
  object Label4: TLabel
    Left = 12
    Top = 233
    Width = 87
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Application:'
  end
  object SpeedButton1: TSpeedButton
    Left = 440
    Top = 16
    Width = 23
    Height = 20
    Hint = 'Select...'
    Flat = True
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1896CE1092CE
      1896CE1896CE1896CE1896CE1896CE1896CE1896CE1092CE1896CE1092CE1896
      CEFF00FFFF00FFFF00FF1092CE1096CEBDEFF794E7F763DFF763DFF763DFF763
      DFF763DFF763DFF763DFF739BEE71896CEFF00FFFF00FFFF00FF1896CE29AED6
      94D7EFDEF7F763DFF763DFF763DFF763DFF763DFF763DFF76BE3FF63DFF7219E
      D61896CEFF00FFFF00FF1086BD6BDBF729A2D6F7FFFFC6EFF76BDFEF6BDFEF6B
      DFEF6BDFEF6BDFEF6BDFEF6BDFEF4ABEDE2996C61896CEFF00FF108ABD6BDBF7
      39B6E7D6F7F7FFFFFFD6F3F7D6F3F7D6F3F7D6F3F7D6F3F7D6F3F7D6F3F7D6F3
      F742AACE1896CEFF00FF1092CEADE3E75ACFDE73C7E7F7FFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF63DBE71896CEFF00FF1896CECEFBF7
      73F3FF39AECE1896CE1092CE1896CE1092CE1896CE1092CE108ABD1086BD1896
      CE1092CEFF00FFFF00FF1092CEEFFFFF73F3FF73F3FF73F3FF73F3FF73EFFF73
      EFFF73EFFF73EFFF6BEBF763DBE71086BDFF00FFFF00FFFF00FF1896CEFFFFFF
      7BF7FF73F7F773F7F77BF7FF7BF7FF73F3F77BF3FF7BF3FF7BF3FF63DBE7108A
      BDFF00FFFF00FFFF00FF1092CEFFFFFF7BF7FF7BFBFF7BF7FF7BF7FF7BF7FF7B
      F7FF7BF7FF7BF7FF7BF7FF63DBE71096CEFF00FFFF00FFFF00FF1896CEFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF63DBE71096
      CEFF00FFFF00FFFF00FF1086BD1096CE1092CE1096CE1092CE1096CE1096CE10
      96CE1096CE1096CE1096CE1096CE1096CEFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    ParentShowHint = False
    ShowHint = True
    OnClick = SpeedButton1Click
  end
  object Bevel1: TBevel
    Left = 379
    Top = 11
    Width = 26
    Height = 26
  end
  object Label8: TLabel
    Left = 349
    Top = 18
    Width = 25
    Height = 13
    Caption = 'Icon:'
  end
  object Image1: TImage
    Left = 384
    Top = 16
    Width = 16
    Height = 18
    Transparent = True
  end
  object SpeedButton5: TSpeedButton
    Left = 412
    Top = 16
    Width = 23
    Height = 20
    Hint = 'Clear icon'
    Flat = True
    Glyph.Data = {
      36050000424D3605000000000000360400002800000010000000100000000100
      0800000000000001000000000000000000000001000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
      A6000020400000206000002080000020A0000020C0000020E000004000000040
      20000040400000406000004080000040A0000040C0000040E000006000000060
      20000060400000606000006080000060A0000060C0000060E000008000000080
      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
      20004000400040006000400080004000A0004000C0004000E000402000004020
      20004020400040206000402080004020A0004020C0004020E000404000004040
      20004040400040406000404080004040A0004040C0004040E000406000004060
      20004060400040606000406080004060A0004060C0004060E000408000004080
      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
      20008000400080006000800080008000A0008000C0008000E000802000008020
      20008020400080206000802080008020A0008020C0008020E000804000008040
      20008040400080406000804080008040A0008040C0008040E000806000008060
      20008060400080606000806080008060A0008060C0008060E000808000008080
      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FDFDFDFDFDFD
      FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD
      FDFDFDFDFDFDFDFDFDFDFDFDFDFD5656FDFDFDFD5656FDFDFDFDFDFDFD566767
      56FDFD565F5F56FDFDFDFDFDFD5667676756565F5F5F56FDFDFDFDFDFDFD56A7
      67675F675F56FDFDFDFDFDFDFDFDFD56A7A75F5F56FDFDFDFDFDFDFDFDFDFD56
      A7A7A76756FDFDFDFDFDFDFDFDFD56AFAFA7A7A7A756FDFDFDFDFDFDFD56AFAF
      A75656A7A7A756FDFDFDFDFDFD56AFAF56FDFD56A7A756FDFDFDFDFDFDFD5656
      FDFDFDFD5656FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD
      FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD}
    ParentShowHint = False
    ShowHint = True
    OnClick = SpeedButton5Click
  end
  object SpeedButton6: TSpeedButton
    Left = 16
    Top = 528
    Width = 23
    Height = 20
    Hint = 'Help...'
    Flat = True
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000000000000000
      0000000000000000000000000000BF9688FF8E2401FF9D2C00FF922600FF0000
      00000000000000000000000000000000000000000000E8E6E0FF000000000000
      0000000000000000000000000000BB9083FFB2470EFFEF8116FFC14600FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BA8E7FFF952C02FFA33906FF982B00FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000DAC6BDFF8E3419FF8E3218FF8D3218FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000CBACA1FF972800FFC44600FFA42F00FFB17B
      6AFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000E0D3CDFF952C03FFE37E27FFCB5100FF8925
      06FFD9C5BEFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008A2D13FFBD5E26FFEB892AFFC045
      00FF8C2504FFC39F91FF00000000000000000000000000000000000000000000
      000000000000000000000000000000000000E3D7D1FF892A0DFFB64F16FFE674
      0EFFCE5100FF912601FFDDC9C1FF000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000089311AFFB643
      01FFF77700FFD05300FF974026FF000000000000000000000000000000000000
      00008A2E13FF882A10FF882A10FFAA6B58FF0000000000000000000000008E28
      06FFF07200FFF67500FF9D3409FF000000000000000000000000000000000000
      00008A2100FFB64003FFB43800FF862205FF0000000000000000000000008C2A
      09FFEF7100FFFB7A00FFA13407FF000000000000000000000000000000000000
      00008A2A0CFFD3732CFFED8827FFAA3700FF9D5441FFC09589FFA05C4BFFAD3A
      00FFFE8100FFED6C00FF983815FF000000000000000000000000000000000000
      0000BD8D81FFA64012FFF4B672FFF2A654FFBF5513FFA73903FFBA4200FFED6C
      00FFF67700FFB74000FFBF8E80FF000000000000000000000000000000000000
      000000000000A15643FFA13B0EFFD88B51FFEFAD6AFFEE9C4AFFE57818FFD055
      00FFA73400FF8A2C11FF00000000000000000000000000000000000000000000
      00000000000000000000D2B2A9FFA8614EFF95320AFF9A350BFF95320AFFA962
      4EFFCBA69CFF0000000000000000000000000000000000000000}
    ParentShowHint = False
    ShowHint = True
    OnClick = SpeedButton6Click
  end
  object Edit1: TEdit
    Left = 112
    Top = 44
    Width = 321
    Height = 21
    TabOrder = 1
  end
  object Edit3: TEdit
    Left = 112
    Top = 72
    Width = 321
    Height = 21
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 112
    Top = 16
    Width = 225
    Height = 21
    TabOrder = 0
  end
  object CheckBox1: TCheckBox
    Left = 20
    Top = 179
    Width = 217
    Height = 17
    Caption = ' Launch application after copy config file '
    TabOrder = 3
    OnClick = CheckBox1Click
  end
  object Edit4: TEdit
    Left = 112
    Top = 229
    Width = 321
    Height = 21
    TabOrder = 5
  end
  object CheckBox2: TCheckBox
    Left = 248
    Top = 179
    Width = 225
    Height = 17
    Caption = ' Delete config file after application ended '
    TabOrder = 4
  end
  object Memo1: TMemo
    Left = 16
    Top = 307
    Width = 221
    Height = 89
    ScrollBars = ssBoth
    TabOrder = 6
  end
  object Memo2: TMemo
    Left = 248
    Top = 307
    Width = 221
    Height = 89
    ScrollBars = ssBoth
    TabOrder = 7
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 404
    Width = 453
    Height = 49
    Caption = ' After launch application '
    TabOrder = 8
    object RadioButton1: TRadioButton
      Left = 20
      Top = 20
      Width = 77
      Height = 17
      Caption = ' No action '
      TabOrder = 0
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 96
      Top = 20
      Width = 121
      Height = 17
      Caption = ' Minimize to taskbar '
      TabOrder = 1
      OnClick = RadioButton2Click
    end
    object RadioButton3: TRadioButton
      Left = 220
      Top = 20
      Width = 101
      Height = 17
      Caption = ' Minimize to tray '
      TabOrder = 2
      OnClick = RadioButton3Click
    end
    object RadioButton7: TRadioButton
      Left = 324
      Top = 20
      Width = 53
      Height = 17
      Caption = ' Hide '
      TabOrder = 3
    end
    object RadioButton8: TRadioButton
      Left = 380
      Top = 20
      Width = 57
      Height = 17
      Caption = ' Exit '
      TabOrder = 4
      OnClick = RadioButton8Click
    end
  end
  object Button1: TButton
    Left = 308
    Top = 528
    Width = 75
    Height = 23
    Caption = 'Save'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 392
    Top = 528
    Width = 75
    Height = 23
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 10
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 464
    Width = 453
    Height = 49
    Caption = ' After ending application '
    TabOrder = 11
    object RadioButton4: TRadioButton
      Left = 20
      Top = 20
      Width = 77
      Height = 17
      Caption = ' No action '
      TabOrder = 0
    end
    object RadioButton5: TRadioButton
      Left = 100
      Top = 20
      Width = 121
      Height = 17
      Caption = ' Restore window '
      TabOrder = 1
    end
    object RadioButton6: TRadioButton
      Left = 220
      Top = 20
      Width = 53
      Height = 17
      Caption = ' Exit '
      TabOrder = 2
    end
  end
  object Edit5: TEdit
    Left = 112
    Top = 257
    Width = 321
    Height = 21
    TabOrder = 12
  end
  object GroupBox3: TGroupBox
    Left = 16
    Top = 104
    Width = 453
    Height = 57
    Caption = ' Auth '
    TabOrder = 13
    object Button3: TButton
      Left = 109
      Top = 21
      Width = 88
      Height = 23
      Caption = 'Set Keyword'
      TabOrder = 0
      OnClick = Button3Click
    end
    object StaticText1: TStaticText
      Left = 212
      Top = 24
      Width = 149
      Height = 17
      Alignment = taCenter
      AutoSize = False
      BorderStyle = sbsSunken
      Caption = 'Keyword not found'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object CheckBox3: TCheckBox
    Left = 20
    Top = 200
    Width = 253
    Height = 17
    Caption = ' Update config in profile after application ended '
    TabOrder = 14
  end
end
