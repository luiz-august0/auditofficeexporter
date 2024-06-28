object frmMenu: TfrmMenu
  Left = 0
  Top = 0
  Caption = 'Menu'
  ClientHeight = 685
  ClientWidth = 1043
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 96
    Top = 56
    object menuCadastro: TMenuItem
      Caption = 'Cadastros'
      object menuClassificaoTCE: TMenuItem
        Caption = 'Classifica'#231#227'o TCE'
        OnClick = menuClassificaoTCEClick
      end
      object menuCadClassificacao: TMenuItem
        Caption = 'Classifica'#231#227'o do sistema x Classifica'#231#227'o do TCE'
        OnClick = menuCadClassificacaoClick
      end
      object menuCadFuncSituacao: TMenuItem
        Caption = 'Funcion'#225'rio x Servidor'
        OnClick = menuCadFuncSituacaoClick
      end
    end
    object menuExportacao: TMenuItem
      Caption = 'Exporta'#231#227'o'
      object menuBalancete: TMenuItem
        Caption = 'Balancete Mensal'
        OnClick = menuBalanceteClick
      end
      object menuMovimentoContabil: TMenuItem
        Caption = 'Movimento Cont'#225'bil Mensal'
        OnClick = menuMovimentoContabilClick
      end
      object menuFolhaServidor: TMenuItem
        Caption = 'Folha Servidor'
        OnClick = menuFolhaServidorClick
      end
    end
    object menuRelatorios: TMenuItem
      Caption = 'Relat'#243'rios'
      object menuRelFuncionarios: TMenuItem
        Caption = 'Rela'#231#227'o de Funcion'#225'rios'
        OnClick = menuRelFuncionariosClick
      end
      object menuRemuneracao: TMenuItem
        Caption = 'Remunera'#231#227'o de Funcion'#225'rios Completo'
        OnClick = menuRemuneracaoClick
      end
    end
  end
end
