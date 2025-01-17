object frmCadClassificacao: TfrmCadClassificacao
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Classifica'#231#227'o do sistema x Classifica'#231#227'o do TCE'
  ClientHeight = 146
  ClientWidth = 816
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
  object Label1: TLabel
    Left = 16
    Top = 32
    Width = 100
    Height = 13
    Caption = 'Classifica'#231#227'o sistema'
  end
  object Label2: TLabel
    Left = 16
    Top = 75
    Width = 83
    Height = 13
    Caption = 'Classifica'#231#227'o TCE'
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 152
    Width = 321
    Height = 393
    DataSource = oDS_ClassificacaoVinculo
    TabOrder = 5
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'classificacao_sistema'
        Title.Caption = 'Classifica'#231#227'o Sistema'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'classificacao_tce'
        Title.Caption = 'Classifica'#231#227'o TCE'
        Width = 150
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator
    Left = 241
    Top = 118
    Width = 240
    Height = 25
    DataSource = oDS_ClassificacaoVinculo
    ConfirmDelete = False
    TabOrder = 2
    OnClick = DBNavigator1Click
  end
  object dbcSistema: TDBComboBox
    Left = 128
    Top = 29
    Width = 241
    Height = 21
    DataField = 'classificacao_sistema'
    DataSource = oDS_ClassificacaoVinculo
    DropDownCount = 30
    TabOrder = 0
    OnChange = dbcSistemaChange
    OnEnter = dbcSistemaEnter
  end
  object dbcTCE: TDBComboBox
    Left = 128
    Top = 72
    Width = 241
    Height = 21
    DataField = 'classificacao_tce'
    DataSource = oDS_ClassificacaoVinculo
    DropDownCount = 30
    TabOrder = 1
    OnChange = dbcTCEChange
    OnEnter = dbcTCEEnter
  end
  object editSistema: TEdit
    Left = 375
    Top = 29
    Width = 274
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 3
  end
  object editTCE: TEdit
    Left = 375
    Top = 72
    Width = 274
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 4
  end
  object Panel1: TPanel
    Left = 685
    Top = 0
    Width = 131
    Height = 146
    Align = alRight
    Alignment = taRightJustify
    TabOrder = 6
    object SpeedButton2: TSpeedButton
      Left = 13
      Top = 7
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
  end
  object oDS_ClassificacaoVinculo: TDataSource
    DataSet = tableClassificacaoXTce
    Left = 640
    Top = 72
  end
  object tableClassificacaoXTce: TZTable
    Connection = dmDados.ZConnection
    BeforePost = tableClassificacaoXTceBeforePost
    BeforeDelete = tableClassificacaoXTceBeforeDelete
    TableName = 'ClassificacaoXTce'
    ShowRecordTypes = [usUnmodified, usModified, usInserted, usDeleted]
    Left = 640
    Top = 24
  end
end
