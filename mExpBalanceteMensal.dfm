object frmBalancete: TfrmBalancete
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Balancete Mensal'
  ClientHeight = 112
  ClientWidth = 707
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefaultSizeOnly
  Visible = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 24
    Top = 63
    Width = 42
    Height = 13
    Caption = 'M'#234's/Ano'
  end
  object Label3: TLabel
    Left = 24
    Top = 87
    Width = 114
    Height = 13
    Caption = 'Caminho da exporta'#231#227'o'
  end
  object Label1: TLabel
    Left = 25
    Top = 36
    Width = 41
    Height = 13
    Caption = 'Empresa'
  end
  object Label4: TLabel
    Left = 23
    Top = 11
    Width = 45
    Height = 13
    Caption = 'Cod. Empresa'
  end
  object editMesAno: TMaskEdit
    Left = 80
    Top = 60
    Width = 48
    Height = 21
    EditMask = '##/####'
    MaxLength = 7
    TabOrder = 2
    Text = '  /    '
  end
  object cbbEmpresa: TComboBox
    Left = 80
    Top = 33
    Width = 289
    Height = 21
    Style = csDropDownList
    TabOrder = 1
  end
  object diretorio: TDirectoryEdit
    Left = 144
    Top = 84
    Width = 291
    Height = 21
    DialogKind = dkWin32
    NumGlyphs = 1
    TabOrder = 3
    Text = ''
  end
  object editCampanha: TEdit
    Left = 80
    Top = 8
    Width = 48
    Height = 21
    NumbersOnly = True
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 576
    Top = 0
    Width = 131
    Height = 112
    Align = alRight
    Alignment = taRightJustify
    TabOrder = 4
    object SpeedButton1: TSpeedButton
      Left = 13
      Top = 8
      Width = 105
      Height = 33
      Caption = 'Exportar'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000020000
        000A0000000F0000001000000010000000100000001100000011000000110000
        001100000011000000100000000B000000030000000000000000000000094633
        2CC160453BFF644A41FFB87D4EFFB97A4AFFB47444FFB06C3DFFA76436FFA764
        36FF583D36FF5B3E37FF3B2821C20000000A00000000000000000000000D6F53
        47FF947869FF6A4F46FFD8B07BFFD7AE77FFD7AB74FFD6A970FFD5A66DFFD4A5
        6AFF5D413AFF684B41FF543931FF0000000E00000000000000000000000C7357
        4AFF987D6EFF70564BFFFFFFFFFFF6EFEAFFF6EFE9FFF6EEE9FFF5EEE9FFF6EE
        E8FF62473FFF715348FF573B33FF0000000F00000000000000000000000B785C
        4EFF9D8273FF765C50FFFFFFFFFFF7F0EBFFF7F0EBFFF7EFEBFFF6EFEAFFF6EF
        EAFF684E44FF72554BFF593E35FF0000000E00000000000000000000000A7C60
        50FFA28777FF7B6154FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBFFF1F1
        F1FF89756EFF8A7269FF5F443BFF0000000C0000000000000000000000097F63
        54FFA78E7DFF977A6AFF967969FF957967FF84695CFF705548FF8F7B73FF0B67
        37FF295D3CFF81746BFF806C63FF0000000C0000000000000000000000088367
        57FFAB9382FF634A41FF614740FF5E463DFF5C443CFF5B433BFF776761FF0A67
        37FF2AAF7FFF106137FF5B6352FF00000016000000030000000000000007866A
        59FFAF9788FF674E44FFF3EAE4FFE8D9CEFFE9DFD7FFE5DBD5FFD8CFC9FF0B6A
        3BFF4EDCB2FF27C48DFF0C7746FF022E179C000201190000000500000006886D
        5CFFB39C8CFF6B5248FFF4ECE6FFEBE3DCFF47916BFF046B38FF046B38FF056B
        38FF3AD7A5FF37D6A2FF32D3A0FF199966FF044A26D5000D063A000000058B70
        5EFFB7A091FF70564DFFF6EFEAFFEBE4DFFF167E4EFF84EDD1FF52E1B6FF4DDF
        B3FF48DDAFFF44DBACFF3FD9A9FF3AD7A6FF32BE8EFF0F6A3FF6000000048E72
        60FFBBA595FF755A50FFF7F1ECFFF1EEEBFF188252FFB8F7E7FFB4F5E6FFAFF4
        E4FF85EDD2FF52E1B7FF4DDFB3FF5DE2BBFF66D0AEFF16794CF6000000026A56
        49BF8F7361FF795E54FF765D52FFAFA19CFF3B8963FF0D814DFF0D804DFF0D80
        4CFF95F1DAFF65E7C2FF83ECCFFF57B28FFF065932D2010E0832000000010000
        000200000003000000030000000300000005000000090000000C000000140D7B
        4BF2AEF6E5FF94E5CEFF339167FD033A1F910001010F00000003000000000000
        0000000000000000000000000000000000000000000000000000000000070F7F
        4EF287CBB3FF106D42E6011C0F4C000000060000000100000000000000000000
        0000000000000000000000000000000000000000000000000000000000051081
        52F1034B2AAE0007041700000003000000010000000000000000}
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 13
      Top = 47
      Width = 105
      Height = 33
      Caption = 'Sair'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000000000020000000C05031A46110852AB190C76E31D0E89FF1C0E89FF190C
        76E4120852AD06031B4D0000000E000000030000000000000000000000000000
        000301010519130A55A9211593FF2225AEFF2430C2FF2535CBFF2535CCFF2430
        C3FF2225AFFF211594FF140B58B20101051E0000000400000000000000020101
        03151C1270CD2522A6FF2D3DCCFF394BD3FF3445D1FF2939CDFF2839CDFF3344
        D0FF394AD4FF2D3CCDFF2523A8FF1C1270D20101051D00000003000000091912
        5BA72A27AAFF2F41D0FF3541C7FF2726ABFF3137BCFF384AD3FF384BD3FF3137
        BCFF2726ABFF3540C7FF2E40D0FF2927ACFF1A115EB10000000D08061C3D3129
        A2FD2C3CCCFF3842C6FF5F5DBDFFEDEDF8FF8B89CEFF3337B9FF3437B9FF8B89
        CEFFEDEDF8FF5F5DBDFF3741C6FF2B3ACDFF3028A4FF0907204A1E185F9F373B
        BCFF3042D0FF2621A5FFECE7ECFFF5EBE4FFF8F2EEFF9491D1FF9491D1FFF8F1
        EDFFF3E9E2FFECE6EBFF2621A5FF2E3FCFFF343ABEFF201A66B0312A92E03542
        CBFF3446D1FF2C2FB5FF8070ADFFEBDBD3FFF4EAE4FFF7F2EDFFF8F1EDFFF4E9
        E2FFEADAD1FF7F6FACFF2B2EB5FF3144D0FF3040CBFF312A95E53E37AEFA3648
        D0FF374AD3FF3A4ED5FF3234B4FF8A7FB9FFF6ECE7FFF5ECE6FFF4EBE5FFF6EB
        E5FF897DB8FF3233B4FF384BD3FF3547D2FF3446D1FF3E37AEFA453FB4FA4557
        D7FF3B50D5FF4C5FDAFF4343B7FF9189C7FFF7EFE9FFF6EEE9FFF6EFE8FFF7ED
        E8FF9087C5FF4242B7FF495DD8FF394CD4FF3F52D4FF443FB3FA403DA1DC5967
        DAFF5B6EDDFF4F4DBAFF8F89CAFFFBF6F4FFF7F1ECFFEDE1D9FFEDE0D9FFF7F0
        EAFFFAF5F2FF8F89CAFF4E4DB9FF576ADCFF5765D9FF403EA4E12E2D70987C85
        DDFF8798E8FF291D9BFFE5DADEFFF6EEEBFFEDDFDAFF816EA9FF816EA9FFEDDF
        D8FFF4ECE7FFE5D9DCFF291D9BFF8494E7FF7A81DDFF33317BAC111125356768
        D0FC9EACEDFF686FCEFF5646A1FFCCB6BCFF7A68A8FF4C4AB6FF4D4BB7FF7A68
        A8FFCBB5BCFF5646A1FF666DCCFF9BAAEEFF696CD0FD1212273F000000043B3B
        79977D84DFFFA5B6F1FF6D74D0FF2D219BFF5151B9FF8EA2ECFF8EA1ECFF5252
        BBFF2D219BFF6B72D0FFA2B3F0FF8086E0FF404183A700000008000000010303
        050C4E509DBC8087E2FFAEBDF3FFA3B6F1FF9DAFF0FF95A9EEFF95A8EEFF9BAD
        EFFFA2B3F0FFACBCF3FF838AE3FF4F52A0C10303051100000002000000000000
        000100000005323464797378D9F8929CEAFFA1AEEFFFB0BFF3FFB0BFF4FFA2AE
        EFFF939DE9FF7479DAF83234647D000000080000000200000000000000000000
        000000000000000000031213232D40437D935D61B5D07378DFFC7378DFFC5D61
        B5D040437D951212223000000004000000010000000000000000}
      OnClick = SpeedButton2Click
    end
    object Edit1: TEdit
      Left = -504
      Top = 8
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'Edit1'
    end
    object ProgressBar1: TProgressBar
      Left = 0
      Top = 86
      Width = 130
      Height = 21
      TabOrder = 1
      Visible = False
    end
  end
end
