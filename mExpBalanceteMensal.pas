unit mExpBalanceteMensal;

interface

uses
	midas,
	midaslib,
	Winapi.Windows,
	Winapi.Messages,
	System.SysUtils,
	System.Variants,
	System.Classes,
	Vcl.Graphics,
	Vcl.Controls,
	Vcl.Forms,
	Vcl.Dialogs,
	Data.DB,
	Datasnap.DBClient,
	Vcl.ExtCtrls,
	Vcl.DBCtrls,
	Vcl.Grids,
	Vcl.DBGrids,
	Vcl.StdCtrls,
	Vcl.Mask,
	ZAbstractRODataset,
	ZAbstractDataset,
	ZAbstractTable,
	ZDataset,
	uGeral,
	RxToolEdit,
	Vcl.Buttons,
	FlatFileDirEdit,
	Vcl.ComCtrls;

type
	TfrmBalancete = class(TForm)
		Label2 : TLabel;
		Label3 : TLabel;
		ProgressBar1 : TProgressBar;
		editMesAno : TMaskEdit;
		cbbEmpresa : TComboBox;
		Label1 : TLabel;
		diretorio : TDirectoryEdit;
		editCampanha : TEdit;
		Label4 : TLabel;
		Panel1 : TPanel;
		SpeedButton1 : TSpeedButton;
		SpeedButton2 : TSpeedButton;
		Edit1 : TEdit;
		procedure SpeedButton1Click(Sender : TObject);
		procedure FormShow(Sender : TObject);
		procedure SpeedButton2Click(Sender : TObject);
		procedure FormClose(Sender : TObject; var Action : TCloseAction);
		private
			{ Private declarations }
			function getDebitos(mes, ano, empresa, classificacao : String) : String;
			function getCreditos(mes, ano, empresa, classificacao : String) : String;
		public
			{ Public declarations }
	end;

var
	frmBalancete : TfrmBalancete;

implementation

uses
	oDmDados;

{$R *.dfm}

{ TfrmBalancete }

procedure TfrmBalancete.FormClose(Sender : TObject; var Action : TCloseAction);
begin
	inherited;
	Action := caFree;
	Release;
	frmBalancete := nil;
end;

procedure TfrmBalancete.FormShow(Sender : TObject);
var
	oCDS_Aux : TClientDataSet;
begin
	oCDS_Aux := TClientDataSet.Create(nil);

	cbbEmpresa.Items.Clear;
	dmDados.ExecSQL('SELECT cd_empresa, razao FROM CRDEmpresa', oCDS_Aux);
	if not oCDS_Aux.IsEmpty then
	begin
		oCDS_Aux.First;
		while not oCDS_Aux.EOF do
		begin
			cbbEmpresa.Items.Add(oCDS_Aux.FieldByName('cd_empresa').AsString + ' - ' + oCDS_Aux.FieldByName('razao').AsString);
			oCDS_Aux.Next;
		end;
	end;

	oCDS_Aux.EmptyDataSet;
	dmDados.ExecSQL('SELECT campanha_cod FROM HistoricoExpCampanha', oCDS_Aux);
	oCDS_Aux.Last;
	editCampanha.Text := oCDS_Aux.FieldByName('campanha_cod').AsString;

	cbbEmpresa.ItemIndex := 0;
	oCDS_Aux.Free;
end;

function TfrmBalancete.getDebitos(mes, ano, empresa, classificacao : String) : String;
var
	oCDS_Debitos : TClientDataSet;
	vsSQL        : string;
begin
	oCDS_Debitos := TClientDataSet.Create(nil);

	vsSQL := ' SELECT FORMAT(ROUND(SUM(vl_lancamento), 2),"#0.00") AS vlrDebitos ' +
		' FROM Lancamento LA ' +
		' INNER JOIN ClassificacaoXTce CXTCE ON CXTCE.classificacao_sistema = LA.cla_conta_deb ' +
		' WHERE MONTH(LA.dt_lancamento) = ' + mes +
		' AND YEAR(LA.dt_lancamento) = ' + ano +
		' AND LA.cla_conta_deb = ' + f_StrToSQL(classificacao) +
		' AND LA.enterprise_id = ' + empresa +
		' AND LA.situacao = "L"';
	dmDados.ExecSQL(vsSQL, oCDS_Debitos);
	if (not oCDS_Debitos.IsEmpty) and (oCDS_Debitos.FieldByName('vlrDebitos').AsString <> '') then
		Result := VirgulaPorPonto(oCDS_Debitos.FieldByName('vlrDebitos').AsString)
	else
		Result := '0.00';

	oCDS_Debitos.Free;
end;

function TfrmBalancete.getCreditos(mes, ano, empresa, classificacao : String) : String;
var
	oCDS_Creditos : TClientDataSet;
	vsSQL         : string;
begin
	oCDS_Creditos := TClientDataSet.Create(nil);

	vsSQL := ' SELECT FORMAT(ROUND(SUM(vl_lancamento), 2),"#0.00") AS vlrCreditos ' +
		' FROM Lancamento LA ' +
		' INNER JOIN ClassificacaoXTce CXTCE ON CXTCE.classificacao_sistema = LA.cla_conta_cre ' +
		' WHERE MONTH(LA.dt_lancamento) = ' + mes +
		' AND YEAR(LA.dt_lancamento) = ' + ano +
		' AND LA.cla_conta_cre = ' + f_StrToSQL(classificacao) +
		' AND LA.enterprise_id = ' + empresa +
		' AND LA.situacao = "L"';
	dmDados.ExecSQL(vsSQL, oCDS_Creditos);
	if (not oCDS_Creditos.IsEmpty) and (oCDS_Creditos.FieldByName('vlrCreditos').AsString <> '') then
		Result := VirgulaPorPonto(oCDS_Creditos.FieldByName('vlrCreditos').AsString)
	else
		Result := '0.00';

	oCDS_Creditos.Free;
end;

procedure TfrmBalancete.SpeedButton1Click(Sender : TObject);
var
	vsSQL, classTCE, linha, mes, ano, empresa : string;
	arq                                       : TextFile;
	oCDS_Exportacao                           : TClientDataSet;
	oCDS_Aux                                  : TClientDataSet;
begin
	oCDS_Exportacao := TClientDataSet.Create(nil);
	oCDS_Aux        := TClientDataSet.Create(nil);

	if Trim(editCampanha.Text) = '' then
	begin
		p_MsgAviso('Cod. Empresa � obrigat�rio');
		editCampanha.SetFocus;
		Exit;
	end;

	if Length(Trim(StringReplace(editMesAno.Text, '/', '', [rfReplaceAll]))) <> 6 then
	begin
		p_MsgAviso('M�s e ano inv�lido');
		editMesAno.SetFocus;
		Exit;
	end;

	if diretorio.Text = '' then
	begin
		p_MsgAviso('Selecione o diret�rio do arquivo a ser exportado');
		diretorio.SetFocus;
		Exit;
	end;

	dmDados.ExecSQL('SELECT campanha_cod FROM HistoricoExpCampanha WHERE campanha_cod = ' + f_StrToSQL(editCampanha.Text), oCDS_Aux);
	if oCDS_Aux.IsEmpty then
		dmDados.ExecSQL('INSERT INTO HistoricoExpCampanha VALUES(' + f_StrToSQL(editCampanha.Text) + ')', nil);

	mes := Copy(editMesAno.Text, 1, POS('/', editMesAno.Text) - 1);
	ano := Copy(editMesAno.Text, POS('/', editMesAno.Text) + 1);

	if POS('-', cbbEmpresa.Text) <> 0 then
		empresa := Copy(cbbEmpresa.Text, 0, POS('-', cbbEmpresa.Text) - 1)
	else
		empresa := cbbEmpresa.Text;

	vsSQL := ' SELECT * FROM( ' +
		' SELECT ISNULL(LA.cla_conta_deb, LA.cla_conta_cre) AS Classificacao, CXTCE.classificacao_tce ' +
		' FROM Lancamento LA ' +
		' INNER JOIN Plano PL ON PL.classificacao = ISNULL(LA.cla_conta_deb, LA.cla_conta_cre) ' +
		' INNER JOIN ClassificacaoXTce CXTCE ON CXTCE.classificacao_sistema = PL.classificacao ' +
		' WHERE MONTH(LA.dt_lancamento) = ' + mes +
		' AND YEAR(LA.dt_lancamento) = ' + ano +
		' AND LA.enterprise_id = ' + empresa + ' ) AS TMP ' +
		' GROUP BY Classificacao, classificacao_tce ' +
		' ORDER BY Classificacao ';
	dmDados.ExecSQL(vsSQL, oCDS_Exportacao);

	if not oCDS_Exportacao.IsEmpty then
	begin
		AssignFile(arq, diretorio.Text + '\BalanceteMensalEstatalXPlanoContabil.txt');
		Rewrite(arq);
		ProgressBar1.Visible  := True;
		ProgressBar1.Max      := oCDS_Exportacao.RecordCount;
		ProgressBar1.Position := 0;

		oCDS_Exportacao.First;
		while not oCDS_Exportacao.EOF do
		begin
			classTCE := '';
			classTCE := oCDS_Exportacao.FieldByName('classificacao_tce').AsString;
			linha    := editCampanha.Text +
				'|' + mes +
				'|' + oCDS_Exportacao.FieldByName('Classificacao').AsString +
				'|' + Copy(classTCE, 1, 1) +
				'|' + Copy(classTCE, 2, 1) +
				'|' + Copy(classTCE, 3, 1) +
				'|' + Copy(classTCE, 4, 1) +
				'|' + Copy(classTCE, 5, 1) +
				'|' + Copy(classTCE, 6, 2) +
				'|' + Copy(classTCE, 8, 2) +
				'|' + Copy(classTCE, 10, 2) +
				'|' + Copy(classTCE, 12, 2) +
				'|' + Copy(classTCE, 14, 2) +
				'|' + Copy(classTCE, 16, 2) +
				'|' + Copy(classTCE, 18, 2) +
				'|' + ano +
				'|' + getDebitos(mes, ano, empresa, oCDS_Exportacao.FieldByName('Classificacao').AsString) +
				'|' + getCreditos(mes, ano, empresa, oCDS_Exportacao.FieldByName('Classificacao').AsString) +
				'|';
			Writeln(arq, linha);

			ProgressBar1.Position := ProgressBar1.Position + 1;
			oCDS_Exportacao.Next;
		end;

		CloseFile(arq);
		p_MsgAviso('Arquivo gravado com sucesso em: ' + #13 + #10 +
				diretorio.Text + '\BalanceteMensalEstatalXPlanoContabil.txt');
		ProgressBar1.Position := 0;
		ProgressBar1.Visible  := False;
	end
	else
		p_MsgAviso('Dados n�o encontrados');

	oCDS_Exportacao.Free;
	oCDS_Aux.Free;
end;

procedure TfrmBalancete.SpeedButton2Click(Sender : TObject);
begin
	Close;
end;

end.
