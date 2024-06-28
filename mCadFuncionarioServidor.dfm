object frmCadFuncionarioServidor: TfrmCadFuncionarioServidor
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Funcion'#225'rio x Servidor'
  ClientHeight = 305
  ClientWidth = 617
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
    Left = 16
    Top = 107
    Width = 63
    Height = 13
    Caption = 'Tipo Servidor'
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 104
    Height = 13
    Caption = 'C'#243'digo do funcion'#225'rio'
  end
  object Label3: TLabel
    Left = 17
    Top = 190
    Width = 88
    Height = 13
    Caption = 'Desconto Patronal'
  end
  object Label4: TLabel
    Left = 17
    Top = 236
    Width = 103
    Height = 13
    Caption = 'Desconto Funcion'#225'rio'
  end
  object Label6: TLabel
    Left = 17
    Top = 64
    Width = 92
    Height = 13
    Caption = 'C'#243'digo da empresa'
  end
  object Label5: TLabel
    Left = 16
    Top = 147
    Width = 56
    Height = 13
    Caption = 'Tipo V'#237'nculo'
  end
  object dbcServidor: TDBComboBox
    Left = 136
    Top = 105
    Width = 49
    Height = 21
    Style = csDropDownList
    DataField = 'tipo_codigo'
    DataSource = oDS_FuncionarioServidor
    DropDownCount = 30
    TabOrder = 2
    OnChange = dbcServidorChange
    OnEnter = dbcServidorEnter
  end
  object dbcFuncionario: TDBComboBox
    Left = 136
    Top = 13
    Width = 49
    Height = 21
    DataField = 'cd_funcionario'
    DataSource = oDS_FuncionarioServidor
    DropDownCount = 30
    TabOrder = 0
    OnChange = dbcFuncionarioChange
    OnEnter = dbcFuncionarioEnter
  end
  object DBGrid1: TDBGrid
    Left = 17
    Top = 309
    Width = 446
    Height = 282
    DataSource = oDS_FuncionarioServidor
    TabOrder = 7
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'cd_funcionario'
        Title.Caption = 'C'#243'digo Funcion'#225'rio'
        Width = 110
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'cd_empresa'
        Title.Caption = 'Empresa'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'tipo_codigo'
        Title.Caption = 'Tipo Servidor'
        Width = 110
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'vinculo_codigo'
        Title.Caption = 'Tipo Vinculo'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Desc_Patronal'
        Title.Caption = 'Desc Patronal'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Desc_Func'
        Title.Caption = 'Desc Func'
        Width = 100
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator
    Left = 103
    Top = 276
    Width = 240
    Height = 25
    DataSource = oDS_FuncionarioServidor
    ConfirmDelete = False
    TabOrder = 6
    OnClick = DBNavigator1Click
  end
  object dbcDescPatronal: TDBComboBox
    Left = 136
    Top = 187
    Width = 73
    Height = 21
    DataField = 'Desc_Patronal'
    DataSource = oDS_FuncionarioServidor
    TabOrder = 4
  end
  object dbcDescFunc: TDBComboBox
    Left = 136
    Top = 233
    Width = 73
    Height = 21
    DataField = 'Desc_Func'
    DataSource = oDS_FuncionarioServidor
    TabOrder = 5
  end
  object editFuncionario: TEdit
    Left = 191
    Top = 13
    Width = 247
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 8
  end
  object editServidor: TEdit
    Left = 191
    Top = 104
    Width = 247
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 9
  end
  object dbcEmpresa: TDBComboBox
    Left = 136
    Top = 61
    Width = 49
    Height = 21
    Style = csDropDownList
    DataField = 'cd_empresa'
    DataSource = oDS_FuncionarioServidor
    DropDownCount = 30
    TabOrder = 1
    OnChange = dbcEmpresaChange
    OnEnter = dbcEmpresaEnter
  end
  object Panel1: TPanel
    Left = 486
    Top = 0
    Width = 131
    Height = 305
    Align = alRight
    Alignment = taRightJustify
    TabOrder = 11
    ExplicitHeight = 265
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
  object dbcVinculo: TDBComboBox
    Left = 136
    Top = 145
    Width = 49
    Height = 21
    Style = csDropDownList
    DataField = 'vinculo_codigo'
    DataSource = oDS_FuncionarioServidor
    DropDownCount = 30
    TabOrder = 3
    OnChange = dbcVinculoChange
    OnEnter = dbcVinculoEnter
  end
  object editVinculo: TEdit
    Left = 191
    Top = 144
    Width = 247
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 10
  end
  object editEmpresa: TEdit
    Left = 191
    Top = 61
    Width = 247
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 12
  end
  object tableFuncionarioServidor: TZTable
    Connection = dmDados.ZConnection
    BeforePost = tableFuncionarioServidorBeforePost
    BeforeDelete = tableFuncionarioServidorBeforeDelete
    TableName = 'FuncionarioSituacaoServidor'
    ShowRecordTypes = [usUnmodified, usModified, usInserted, usDeleted]
    Left = 416
    Top = 240
  end
  object oDS_FuncionarioServidor: TDataSource
    DataSet = tableFuncionarioServidor
    Left = 344
    Top = 192
  end
end
