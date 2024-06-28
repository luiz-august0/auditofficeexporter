unit mRelRelacaoFuncionariosComp;

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
	TfrmRelacaoFuncionariosComp = class(TForm)
		Label3 : TLabel;
		Label1 : TLabel;
		diretorio : TDirectoryEdit;
		Panel1 : TPanel;
		SpeedButton1 : TSpeedButton;
		SpeedButton2 : TSpeedButton;
		Edit1 : TEdit;
		ProgressBar1 : TProgressBar;
		Label5 : TLabel;
		editMesAno : TMaskEdit;
		cbbEmpresa : TComboBox;
		procedure SpeedButton1Click(Sender : TObject);
		procedure FormShow(Sender : TObject);
		procedure SpeedButton2Click(Sender : TObject);
		procedure FormClose(Sender : TObject; var Action : TCloseAction);
		private
			{ Private declarations }
			function getSituacao(Data, funcionario, empresa : String) : String;
			function getProventos(empresa, funcionario, mes, ano : String) : String;
			function getATS(empresa, funcionario, mes, ano : String) : string;
			function getOutros(empresa, funcionario, mes, ano : String) : string;
		public
			{ Public declarations }
	end;

var
	frmRelacaoFuncionariosComp : TfrmRelacaoFuncionariosComp;

implementation

uses
	oDmDados,
	ComObj,
	Clipbrd;

{$R *.dfm}

{ TfrmBalancete }

procedure TfrmRelacaoFuncionariosComp.FormClose(Sender : TObject; var Action : TCloseAction);
begin
	inherited;
	Action := caFree;
	Release;
	frmRelacaoFuncionariosComp := nil;
end;

procedure TfrmRelacaoFuncionariosComp.FormShow(Sender : TObject);
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

	cbbEmpresa.ItemIndex := 0;
	oCDS_Aux.Free;
end;

function TfrmRelacaoFuncionariosComp.getSituacao(Data, funcionario, empresa : String) : String;
var
	oCDS_Situacao : TClientDataSet;
	vsSQL         : string;
begin
	oCDS_Situacao := TClientDataSet.Create(nil);

	vsSQL := ' SELECT TOP 1 TP.descricao ' +
		' FROM FunMovimentacao FUNMOV ' +
		' INNER JOIN TiposAlfanumericos TP ' +
		' ON FUNMOV.tipo_afastamento = TP.codigo ' +
		' WHERE FUNMOV.cd_empresa = ' + empresa +
		' AND FUNMOV.cd_funcionario = ' + funcionario +
		' AND convert(char, FUNMOV.dt_movimentacao, 23) <= ' + f_StrToSQL(Data) +
		' AND convert(char, FUNMOV.dt_retorno, 23) <= ' + f_StrToSQL(Data) +
		' ORDER BY dt_movimentacao DESC ';
	dmDados.ExecSQL(vsSQL, oCDS_Situacao);
	if not oCDS_Situacao.IsEmpty then
		Result := oCDS_Situacao.FieldByName('descricao').AsString
	else
		Result := 'TRABALHANDO';

	oCDS_Situacao.Free;
end;

function TfrmRelacaoFuncionariosComp.getProventos(empresa, funcionario, mes, ano : String) : String;
var
	vsSQL          : String;
	oCDS_Proventos : TClientDataSet;
begin
	oCDS_Proventos := TClientDataSet.Create(nil);

	vsSQL := ' SELECT FORMAT(ROUND(SUM(valor),2), "#0.00") AS total FROM ( ' +
		' SELECT DISTINCT PROCE.valor FROM ProcEvento PROCE ' +
		' INNER JOIN EventoGVigencia EVG ' +
		' ON PROCE.cd_evento = EVG.cd_evento ' +
		' WHERE EVG.tp_evento = "V" ' +
		' AND PROCE.cd_empresa = ' + empresa +
		' AND PROCE.cd_funcionario = ' + funcionario +
		' AND PROCE.mes = ' + mes +
		' AND PROCE.ano = ' + ano +
		' AND PROCE.cd_evento IN (01, 223) ' +
		' ) AS TMP ';
	dmDados.ExecSQL(vsSQL, oCDS_Proventos);
	if not oCDS_Proventos.IsEmpty then
		Result := VirgulaPorPonto(oCDS_Proventos.FieldByName('total').AsString)
	else
		Result := '0.00';

	oCDS_Proventos.Free;
end;

function TfrmRelacaoFuncionariosComp.getATS(empresa, funcionario, mes, ano : String) : string;
var
	vsSQL, vsEventos : String;
	oCDS_Ats         : TClientDataSet;
begin
	oCDS_Ats := TClientDataSet.Create(nil);

	vsSQL := ' SELECT PROCE.cd_evento FROM ProcEvento PROCE ' +
		' INNER JOIN EventoGVigencia EVG ' +
		' ON PROCE.cd_evento = EVG.cd_evento ' +
		' WHERE EVG.tp_evento = "V" ' +
		' AND PROCE.cd_empresa = ' + empresa +
		' AND PROCE.cd_funcionario = ' + funcionario +
		' AND PROCE.mes = ' + mes +
		' AND PROCE.ano = ' + ano +
		' AND PROCE.cd_evento IN (74, 306) ' +
		' GROUP BY PROCE.cd_evento ';
	dmDados.ExecSQL(vsSQL, oCDS_Ats);

	if oCDS_Ats.RecordCount > 1 then
		vsEventos := '74'
	else
		vsEventos := '74,306';

	vsSQL := ' SELECT FORMAT(ROUND(SUM(valor),2), "#0.00") AS total FROM ( ' +
		' SELECT DISTINCT PROCE.valor FROM ProcEvento PROCE ' +
		' INNER JOIN EventoGVigencia EVG ' +
		' ON PROCE.cd_evento = EVG.cd_evento ' +
		' WHERE EVG.tp_evento = "V" ' +
		' AND PROCE.cd_empresa = ' + empresa +
		' AND PROCE.cd_funcionario = ' + funcionario +
		' AND PROCE.mes = ' + mes +
		' AND PROCE.ano = ' + ano +
		' AND PROCE.cd_evento IN (' + vsEventos + ')' +
		' ) AS TMP ';
	oCDS_Ats.EmptyDataSet;
	dmDados.ExecSQL(vsSQL, oCDS_Ats);
	if not oCDS_Ats.IsEmpty then
		Result := VirgulaPorPonto(oCDS_Ats.FieldByName('total').AsString)
	else
		Result := '0.00';

	oCDS_Ats.Free;
end;

function TfrmRelacaoFuncionariosComp.getOutros(empresa, funcionario, mes, ano : String) : string;
var
	vsSQL       : String;
	oCDS_Outros : TClientDataSet;
begin
	oCDS_Outros := TClientDataSet.Create(nil);

	vsSQL := ' SELECT FORMAT(ROUND(SUM(valor),2), "#0.00") AS total FROM ( ' +
		' SELECT DISTINCT PROCE.valor FROM ProcEvento PROCE ' +
		' INNER JOIN EventoGVigencia EVG ' +
		' ON PROCE.cd_evento = EVG.cd_evento ' +
		' WHERE EVG.tp_evento = "V" ' +
		' AND PROCE.cd_empresa = ' + empresa +
		' AND PROCE.cd_funcionario = ' + funcionario +
		' AND PROCE.mes = ' + mes +
		' AND PROCE.ano = ' + ano +
		' AND PROCE.cd_evento NOT IN (01, 223, 74, 306) ' +
		' ) AS TMP ';
	dmDados.ExecSQL(vsSQL, oCDS_Outros);
	if not oCDS_Outros.IsEmpty then
		Result := VirgulaPorPonto(oCDS_Outros.FieldByName('total').AsString)
	else
		Result := '0.00';

	oCDS_Outros.Free;
end;

procedure TfrmRelacaoFuncionariosComp.SpeedButton1Click(Sender : TObject);
var
	vsSQL, linha, mes, ano, Data, empresa : string;
	Excel, Sheet                          : OleVariant;
	i                                     : Integer;
	arq                                   : TextFile;
	oCDS_Exportacao                       : TClientDataSet;
begin
	oCDS_Exportacao := TClientDataSet.Create(nil);

	if Length(Trim(StringReplace(editMesAno.Text, '/', '', [rfReplaceAll]))) <> 6 then
	begin
		p_MsgAviso('Data de referência inválida');
		editMesAno.SetFocus;
		Exit;
	end;

	if diretorio.Text = '' then
	begin
		p_MsgAviso('Selecione o diretório do arquivo a ser exportado');
		diretorio.SetFocus;
		Exit;
	end;

	mes := Copy(editMesAno.Text, 1, Pos('/', editMesAno.Text) - 1);
	ano := Copy(editMesAno.Text, Pos('/', editMesAno.Text) + 1);

	if Pos('-', cbbEmpresa.Text) <> 0 then
		empresa := Copy(cbbEmpresa.Text, 0, Pos('-', cbbEmpresa.Text) - 1)
	else
		empresa := cbbEmpresa.Text;

	Data := Copy(editMesAno.Text, Pos('/', editMesAno.Text) + 1) + '-' +
		Copy(editMesAno.Text, 1, Pos('/', editMesAno.Text) - 1) + '-' +
		UltimoDiaDoMes(Trim(StringReplace(editMesAno.Text, '/', '', [rfReplaceAll])));

	vsSQL := ' SELECT EST.descricao AS Setor, FUN.cd_funcionario, FUN.nome, ' +
		' (SELECT TOP 1 nr_horas_semanais FROM FunSalario ' +
		' WHERE cd_funcionario = FUN.cd_funcionario ' +
		' AND cd_empresa = FUN.cd_empresa ' +
		' ORDER BY dt_salario DESC) AS horas_semanais, ' +
		' (SELECT TOP 1 Func.descricao FROM FunFuncao FFuncao ' +
		' INNER JOIN Funcao Func ON FFuncao.cd_funcao = Func.cd_funcao ' +
		' AND FFuncao.cd_empresa = Func.enterprise_id ' +
		' WHERE FFuncao.cd_empresa = FUN.cd_empresa ' +
		' AND FFuncao.cd_funcionario = FUN.cd_funcionario ' +
		' ORDER BY dt_funcao DESC) AS descricao ' +
		' FROM Funcionario FUN ' +
		' INNER JOIN FunLotacao FUNLOT ' +
		' ON FUNLOT.cd_empresa = FUN.cd_empresa ' +
		' AND FUNLOT.cd_funcionario = FUN.cd_funcionario ' +
		' INNER JOIN Estrutura EST ' +
		' ON FUNLOT.cd_empresa = EST.cd_empresa ' +
		' AND FUNLOT.cd_filial = EST.cd_filial ' +
		' AND FUNLOT.cd_nivel1 = EST.cd_nivel1 ' +
		' AND FUNLOT.cd_nivel2 = EST.cd_nivel2 ' +
		' AND FUNLOT.cd_nivel3 = EST.cd_nivel3 ' +
		' WHERE FUN.cd_empresa = ' + empresa +
		' AND (SELECT cd_funcionario FROM FunMovimentacao ' +
		' WHERE tipo_movimentacao = 2 ' +
		' AND convert(char, dt_movimentacao, 23) <= ' + f_StrToSQL(Data) +
		' AND cd_funcionario = FUN.cd_funcionario) IS NULL ' +
		' ORDER BY EST.descricao, FUN.nome ASC ';
	dmDados.ExecSQL(vsSQL, oCDS_Exportacao);

	if not oCDS_Exportacao.IsEmpty then
	begin
		Excel := CreateOleObject('Excel.Application');
		// ** Adiciona uma pasta de trabalho
		Excel.WorkBooks.Add;
		// deleta as planilhas que sobraram
		// Excel.WorkBooks[1].Sheets[2].Delete;
		Sheet := Excel.WorkBooks[1].Sheets[1];
		// ** Exporta dados
		Sheet.Range('A1:A1')                  := 'Remuneração de Funcionários Completo';
		Sheet.Range('A3')                     := 'LOTAÇÃO';
		Sheet.Range('B3')                     := 'MAT';
		Sheet.Range('C3')                     := 'NOME';
		Sheet.Range('D3')                     := 'FUNÇÃO';
		Sheet.Range('E3')                     := 'HORAS';
		Sheet.Range('F3')                     := 'SITUAÇÃO';
		Sheet.Range('G3')                     := 'PROVENTOS';
		Sheet.Range('H3')                     := 'ATS';
		Sheet.Range('I3')                     := 'OUTROS';
		Sheet.Range('J3')                     := 'VALOR BRUTO';
		Sheet.Range['A1:J1'].MergeCells       := true;
		Sheet.Range['A1'].HorizontalAlignment := 3;
		Sheet.Range['A1'].Font.Bold           := true;
		Sheet.Range['A3:J3'].Font.Bold        := true;

		ProgressBar1.Visible  := true;
		ProgressBar1.Max      := oCDS_Exportacao.RecordCount;
		ProgressBar1.Position := 0;

		oCDS_Exportacao.First;
		i := 4; // ** Controle de linha do Excel
		while not oCDS_Exportacao.EOF do
		begin
			Sheet.Range('A' + inttostr(i))              := oCDS_Exportacao.FieldByName('Setor').AsString;
			Sheet.Range('B' + inttostr(i))              := oCDS_Exportacao.FieldByName('cd_funcionario').AsString;
			Sheet.Range('C' + inttostr(i))              := oCDS_Exportacao.FieldByName('nome').AsString;
			Sheet.Range('D' + inttostr(i))              := oCDS_Exportacao.FieldByName('descricao').AsString;
			Sheet.Range('E' + inttostr(i))              := oCDS_Exportacao.FieldByName('horas_semanais').AsString;
			Sheet.Range('F' + inttostr(i))              := getSituacao(Data, oCDS_Exportacao.FieldByName('cd_funcionario').AsString, empresa);
			Sheet.Range('G' + inttostr(i))              := getProventos(empresa, oCDS_Exportacao.FieldByName('cd_funcionario').AsString, mes, ano);
			Sheet.Range('H' + inttostr(i))              := getATS(empresa, oCDS_Exportacao.FieldByName('cd_funcionario').AsString, mes, ano);
			Sheet.Range('I' + inttostr(i))              := getOutros(empresa, oCDS_Exportacao.FieldByName('cd_funcionario').AsString, mes, ano);
			Sheet.Range('J' + inttostr(i))              := '=SUM(' + 'G' + inttostr(i) + ':' + 'I' + inttostr(i) + ')';
			Sheet.Range['G' + inttostr(i)].NumberFormat := '##############################0,00';
			Sheet.Range['H' + inttostr(i)].NumberFormat := '##############################0,00';
			Sheet.Range['I' + inttostr(i)].NumberFormat := '##############################0,00';
			Sheet.Range['J' + inttostr(i)].NumberFormat := '##############################0,00';

			ProgressBar1.Position := ProgressBar1.Position + 1;
			i                     := i + 1;
			oCDS_Exportacao.Next;
		end;

		oCDS_Exportacao.EmptyDataSet;
		dmDados.ExecSQL(' SELECT EVG.descricao ' +
				' FROM ProcEvento PROCE ' +
				' INNER JOIN EventoGVigencia EVG ' +
				' ON PROCE.cd_evento = EVG.cd_evento ' +
				' WHERE EVG.tp_evento = "V" ' +
				' AND PROCE.cd_empresa = ' + empresa +
				' AND PROCE.mes = ' + mes +
				' AND PROCE.ano = ' + ano +
				' AND PROCE.cd_evento NOT IN (01, 223, 74, 306) ' +
				' GROUP BY EVG.descricao ', oCDS_Exportacao);
		if not oCDS_Exportacao.IsEmpty then
		begin
			Sheet.Range('C' + inttostr(i + 1))           := 'OUTROS';
			Sheet.Range['C' + inttostr(i + 1)].Font.Bold := true;

			i := i + 2;
			oCDS_Exportacao.First;
			while not oCDS_Exportacao.EOF do
			begin
				Sheet.Range('C' + inttostr(i)) := oCDS_Exportacao.FieldByName('descricao').AsString;

				i := i + 1;
				oCDS_Exportacao.Next;
			end;
		end;

		Sheet.Cells.Font.Size := 10;
		Sheet.Cells.Font.Name := 'Arial';
		Sheet.Cells.Columns.AutoFit; // ** Dimensiona as celulas conforme o conteúdo
		Excel.Visible := true; // ** Mostra o EXCEL
		Excel.ActiveWorkBook.SaveAs(diretorio.Text + '\Remuneração de Funcionários Completo.xlsx');
		// Excel.Quit;  //** Encerra o aplicativo
		Sheet := unassigned;

		ProgressBar1.Position := 0;
		ProgressBar1.Visible  := False;
	end
	else
		p_MsgAviso('Dados não encontrados');

	oCDS_Exportacao.Free;
end;

procedure TfrmRelacaoFuncionariosComp.SpeedButton2Click(Sender : TObject);
begin
	Close;
end;

end.
