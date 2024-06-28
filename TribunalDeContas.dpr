program TribunalDeContas;

uses
  Vcl.Forms,
  uMenu in 'uMenu.pas' {frmMenu},
  mCadClassificacao in 'mCadClassificacao.pas' {frmCadClassificacao},
  oDmDados in 'oDmDados.pas' {dmDados: TDataModule},
  uGeral in 'uGeral.pas',
  AnsiStringReplaceJOHIA32Unit12 in 'AnsiStringReplaceJOHIA32Unit12.pas',
  mCadClassificacaoTCE in 'mCadClassificacaoTCE.pas' {frmCadClassificacaoTCE},
  mCadFuncionarioServidor in 'mCadFuncionarioServidor.pas' {frmCadFuncionarioServidor},
  mExpBalanceteMensal in 'mExpBalanceteMensal.pas' {frmBalancete},
  mExpMovContabilMensal in 'mExpMovContabilMensal.pas' {frmMovContabil},
  mExpFolhaServidor in 'mExpFolhaServidor.pas' {frmFolhaServidor},
  mRelRelacaoFuncionarios in 'mRelRelacaoFuncionarios.pas' {frmRelacaoFuncionarios},
  mRelRelacaoFuncionariosComp in 'mRelRelacaoFuncionariosComp.pas' {frmRelacaoFuncionariosComp},
  mCreateTables in 'mCreateTables.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmDados, dmDados);
  Application.CreateForm(TfrmMenu, frmMenu);
  Application.Run;
end.
