unit mRelRelacaoFuncionarios;

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
	TfrmRelacaoFuncionarios = class(TForm)
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
		public
			{ Public declarations }
	end;

var
	frmRelacaoFuncionarios : TfrmRelacaoFuncionarios;

implementation

uses
	oDmDados,
	ComObj,
	Clipbrd;

{$R *.dfm}

{ TfrmBalancete }

procedure TfrmRelacaoFuncionarios.FormClose(Sender : TObject; var Action : TCloseAction);
begin
	inherited;
	Action := caFree;
	Release;
	frmRelacaoFuncionarios := nil;
end;

procedure TfrmRelacaoFuncionarios.FormShow(Sender : TObject);
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

function TfrmRelacaoFuncionarios.getSituacao(Data, funcionario, empresa : String) : String;
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

procedure TfrmRelacaoFuncionarios.SpeedButton1Click(Sender : TObject);
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
		Sheet.Range('A1:A1')                  := 'Relação de Funcionários';
		Sheet.Range('A3')                     := 'LOTAÇÃO';
		Sheet.Range('B3')                     := 'MAT';
		Sheet.Range('C3')                     := 'NOME';
		Sheet.Range('D3')                     := 'FUNÇÃO';
		Sheet.Range('E3')                     := 'HORAS';
		Sheet.Range('F3')                     := 'SITUAÇÃO';
		Sheet.Range['A1:F1'].MergeCells       := true;
		Sheet.Range['A1'].HorizontalAlignment := 3;
		Sheet.Range['A1'].Font.Bold           := true;
		Sheet.Range['A3:F3'].Font.Bold        := true;

		ProgressBar1.Visible  := true;
		ProgressBar1.Max      := oCDS_Exportacao.RecordCount;
		ProgressBar1.Position := 0;

		oCDS_Exportacao.First;
		i := 4; // ** Controle de linha do Excel
		while not oCDS_Exportacao.EOF do
		begin
			Sheet.Range('A' + inttostr(i)) := oCDS_Exportacao.FieldByName('Setor').AsString;
			Sheet.Range('B' + inttostr(i)) := oCDS_Exportacao.FieldByName('cd_funcionario').AsString;
			Sheet.Range('C' + inttostr(i)) := oCDS_Exportacao.FieldByName('nome').AsString;
			Sheet.Range('D' + inttostr(i)) := oCDS_Exportacao.FieldByName('descricao').AsString;
			Sheet.Range('E' + inttostr(i)) := oCDS_Exportacao.FieldByName('horas_semanais').AsString;
			Sheet.Range('F' + inttostr(i)) := getSituacao(Data, oCDS_Exportacao.FieldByName('cd_funcionario').AsString, empresa);

			ProgressBar1.Position := ProgressBar1.Position + 1;
			i                     := i + 1;
			oCDS_Exportacao.Next;
		end;

		Sheet.Cells.Font.Size := 10;
		Sheet.Cells.Font.Name := 'Arial';
		Sheet.Cells.Columns.AutoFit; // ** Dimensiona as celulas conforme o conteúdo
		Excel.Visible := true; // ** Mostra o EXCEL
		Excel.ActiveWorkBook.SaveAs(diretorio.Text + '\Relação de Funcionários.xlsx');
		// Excel.Quit;  //** Encerra o aplicativo
		Sheet := unassigned;

		ProgressBar1.Position := 0;
		ProgressBar1.Visible  := False;
	end
	else
		p_MsgAviso('Dados não encontrados');

	oCDS_Exportacao.Free;
end;

procedure TfrmRelacaoFuncionarios.SpeedButton2Click(Sender : TObject);
begin
	Close;
end;

end.
