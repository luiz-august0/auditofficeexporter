unit mCadFuncionarioServidor;

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
	Vcl.DBCGrids,
	Vcl.Grids,
	Vcl.DBGrids,
	Datasnap.DBClient,
	Vcl.StdCtrls,
	Vcl.Mask,
	Vcl.DBCtrls,
	Vcl.ExtCtrls,
	ZAbstractRODataset,
	ZAbstractDataset,
	ZAbstractTable,
	ZDataset,
	uGeral,
	Vcl.Buttons;

type
	TfrmCadFuncionarioServidor = class(TForm)
		tableFuncionarioServidor : TZTable;
		oDS_FuncionarioServidor : TDataSource;
		Label2 : TLabel;
		dbcServidor : TDBComboBox;
		dbcFuncionario : TDBComboBox;
		Label1 : TLabel;
		DBNavigator1 : TDBNavigator;
		DBGrid1 : TDBGrid;
		Label3 : TLabel;
		Label4 : TLabel;
		dbcDescPatronal : TDBComboBox;
		dbcDescFunc : TDBComboBox;
		editFuncionario : TEdit;
		editServidor : TEdit;
		dbcEmpresa : TDBComboBox;
		Label6 : TLabel;
		Panel1 : TPanel;
		SpeedButton2 : TSpeedButton;
		Edit1 : TEdit;
		Label5 : TLabel;
		dbcVinculo : TDBComboBox;
		editVinculo : TEdit;
		editEmpresa : TEdit;
		procedure dbcFuncionarioChange(Sender : TObject);
		procedure dbcFuncionarioEnter(Sender : TObject);
		procedure dbcServidorChange(Sender : TObject);
		procedure dbcServidorEnter(Sender : TObject);
		procedure dbcVinculoChange(Sender : TObject);
		procedure dbcVinculoEnter(Sender : TObject);
		procedure DBNavigator1Click(Sender : TObject; Button : TNavigateBtn);
		procedure tableFuncionarioServidorBeforePost(DataSet : TDataSet);
		procedure FormShow(Sender : TObject);
		procedure SpeedButton2Click(Sender : TObject);
		procedure FormClose(Sender : TObject; var Action : TCloseAction);
		procedure tableFuncionarioServidorBeforeDelete(DataSet : TDataSet);
		procedure dbcEmpresaChange(Sender : TObject);
		procedure dbcEmpresaEnter(Sender : TObject);
		private
			{ Private declarations }
			procedure pCarregaDados;
			procedure getFuncionario;
			procedure getNomeServidor;
			procedure getNomeEmpresa;
			procedure getNomeVinculo;
			procedure validaCampos;
		public
			{ Public declarations }
	end;

var
	frmCadFuncionarioServidor : TfrmCadFuncionarioServidor;

implementation

uses
	oDmDados;

{$R *.dfm}


procedure TfrmCadFuncionarioServidor.pCarregaDados;
var
	oCDS_Func, oCDS_Empresa, oCDS_Servidor, oCDS_Vinculo, oCDS_DescPatronal, oCDS_DescFunc : TClientDataSet;

begin
	oCDS_Func         := TClientDataSet.Create(nil);
	oCDS_Empresa      := TClientDataSet.Create(nil);
	oCDS_Servidor     := TClientDataSet.Create(nil);
	oCDS_Vinculo      := TClientDataSet.Create(nil);
	oCDS_DescPatronal := TClientDataSet.Create(nil);
	oCDS_DescFunc     := TClientDataSet.Create(nil);

	if dmDados.vbConectado then
		tableFuncionarioServidor.Active := True;

	dmDados.ExecSQL('SELECT cd_funcionario FROM Funcionario', oCDS_Func);
	if not oCDS_Func.IsEmpty then
	begin
		oCDS_Func.First;
		while not oCDS_Func.EOF do
		begin
			dbcFuncionario.Items.Add(oCDS_Func.FieldByName('cd_funcionario').AsString);
			oCDS_Func.Next;
		end;
	end;

	dmDados.ExecSQL('SELECT cd_empresa FROM CRDEmpresa', oCDS_Empresa);
	if not oCDS_Empresa.IsEmpty then
	begin
		oCDS_Empresa.First;
		while not oCDS_Empresa.EOF do
		begin
			dbcEmpresa.Items.Add(oCDS_Empresa.FieldByName('cd_empresa').AsString);
			oCDS_Empresa.Next;
		end;
	end;

	dmDados.ExecSQL('SELECT tipo_codigo FROM TiposFuncionario', oCDS_Servidor);
	if not oCDS_Servidor.IsEmpty then
	begin
		oCDS_Servidor.First;
		while not oCDS_Servidor.EOF do
		begin
			dbcServidor.Items.Add(oCDS_Servidor.FieldByName('tipo_codigo').AsString);
			oCDS_Servidor.Next;
		end;
	end;

	dmDados.ExecSQL('SELECT vinculo_codigo FROM TiposVinculoFuncionario', oCDS_Vinculo);
	if not oCDS_Vinculo.IsEmpty then
	begin
		oCDS_Vinculo.First;
		while not oCDS_Vinculo.EOF do
		begin
			dbcVinculo.Items.Add(oCDS_Vinculo.FieldByName('vinculo_codigo').AsString);
			oCDS_Vinculo.Next;
		end;
	end;

	dmDados.ExecSQL('SELECT FORMAT(Desc_Patronal, "0.00") AS Desc_Patronal FROM DescontosFuncionario GROUP BY Desc_Patronal', oCDS_DescPatronal);
	if not oCDS_DescPatronal.IsEmpty then
	begin
		oCDS_DescPatronal.First;
		while not oCDS_DescPatronal.EOF do
		begin
			dbcDescPatronal.Items.Add(oCDS_DescPatronal.FieldByName('Desc_Patronal').AsString);
			oCDS_DescPatronal.Next;
		end;
	end;

	dmDados.ExecSQL('SELECT FORMAT(Desc_Func, "0.00") AS Desc_Func FROM DescontosFuncionario GROUP BY Desc_Func', oCDS_DescFunc);
	if not oCDS_DescFunc.IsEmpty then
	begin
		oCDS_DescFunc.First;
		while not oCDS_DescFunc.EOF do
		begin
			dbcDescFunc.Items.Add(oCDS_DescFunc.FieldByName('Desc_Func').AsString);
			oCDS_DescFunc.Next;
		end;
	end;

	getFuncionario;
	getNomeEmpresa;
	getNomeServidor;
	getNomeVinculo;

	oCDS_Func.Free;
	oCDS_Empresa.Free;
	oCDS_Servidor.Free;
	oCDS_Vinculo.Free;
	oCDS_DescPatronal.Free;
	oCDS_DescFunc.Free;
end;

procedure TfrmCadFuncionarioServidor.FormClose(Sender : TObject; var Action : TCloseAction);
begin
	inherited;
	Action := caFree;
	Release;
	frmCadFuncionarioServidor := nil;
end;

procedure TfrmCadFuncionarioServidor.FormShow(Sender : TObject);
begin
	dbcFuncionario.Items.Clear;
	dbcEmpresa.Items.Clear;
	dbcServidor.Items.Clear;
	dbcVinculo.Items.Clear;
	dbcDescPatronal.Items.Clear;
	dbcDescFunc.Items.Clear;
	pCarregaDados;
end;

procedure TfrmCadFuncionarioServidor.getFuncionario;
var
	oCDS_Funcionario : TClientDataSet;
begin
	oCDS_Funcionario := TClientDataSet.Create(nil);
	if dbcFuncionario.Text <> '' then
	begin
		dmDados.ExecSQL('SELECT nome FROM Funcionario WHERE cd_funcionario = ' + dbcFuncionario.Text, oCDS_Funcionario);
		editFuncionario.Text := oCDS_Funcionario.FieldByName('nome').AsString;

		oCDS_Funcionario.EmptyDataSet;
		dmDados.ExecSQL('SELECT cd_funcionario FROM FuncionarioSituacaoServidor WHERE cd_funcionario = ' + dbcFuncionario.Text, oCDS_Funcionario);
		if not oCDS_Funcionario.IsEmpty then
		begin
			tableFuncionarioServidor.Filtered := False;
			tableFuncionarioServidor.Filter   := 'cd_funcionario = ' + oCDS_Funcionario.FieldByName('cd_funcionario').AsString;
			tableFuncionarioServidor.Filtered := True;
		end;
		tableFuncionarioServidor.Filtered := False;
	end
	else
		editFuncionario.Text := '';

	oCDS_Funcionario.Free;
end;

procedure TfrmCadFuncionarioServidor.getNomeEmpresa;
var
	oCDS_Empresa : TClientDataSet;
begin
	oCDS_Empresa := TClientDataSet.Create(nil);
	if dbcEmpresa.Text <> '' then
	begin
		dmDados.ExecSQL('SELECT razao FROM CRDEmpresa WHERE cd_empresa = ' + dbcEmpresa.Text, oCDS_Empresa);
		editEmpresa.Text := oCDS_Empresa.FieldByName('razao').AsString;
	end
	else
		editEmpresa.Text := '';

	oCDS_Empresa.Free;
end;

procedure TfrmCadFuncionarioServidor.getNomeServidor;
var
	oCDS_Servidor : TClientDataSet;
begin
	oCDS_Servidor := TClientDataSet.Create(nil);
	if dbcServidor.Text <> '' then
	begin
		dmDados.ExecSQL('SELECT tipo_descricao FROM TiposFuncionario WHERE tipo_codigo = ' + dbcServidor.Text, oCDS_Servidor);
		editServidor.Text := oCDS_Servidor.FieldByName('tipo_descricao').AsString;
	end
	else
		editServidor.Text := '';

	oCDS_Servidor.Free;
end;

procedure TfrmCadFuncionarioServidor.getNomeVinculo;
var
	oCDS_Vinculo : TClientDataSet;
begin
	oCDS_Vinculo := TClientDataSet.Create(nil);
	if dbcVinculo.Text <> '' then
	begin
		dmDados.ExecSQL('SELECT descricao FROM TiposVinculoFuncionario WHERE vinculo_codigo = ' + dbcVinculo.Text, oCDS_Vinculo);
		editVinculo.Text := oCDS_Vinculo.FieldByName('descricao').AsString;
	end
	else
		editVinculo.Text := '';

	oCDS_Vinculo.Free;
end;

procedure TfrmCadFuncionarioServidor.dbcFuncionarioChange(Sender : TObject);
begin
	getFuncionario;
end;

procedure TfrmCadFuncionarioServidor.dbcFuncionarioEnter(Sender : TObject);
begin
	getFuncionario;
end;

procedure TfrmCadFuncionarioServidor.dbcEmpresaChange(Sender : TObject);
begin
	getNomeEmpresa;
end;

procedure TfrmCadFuncionarioServidor.dbcEmpresaEnter(Sender : TObject);
begin
	getNomeEmpresa;
end;

procedure TfrmCadFuncionarioServidor.dbcServidorChange(Sender : TObject);
begin
	getNomeServidor;
end;

procedure TfrmCadFuncionarioServidor.dbcServidorEnter(Sender : TObject);
begin
	getNomeServidor;
end;

procedure TfrmCadFuncionarioServidor.dbcVinculoChange(Sender : TObject);
begin
	getNomeVinculo;
end;

procedure TfrmCadFuncionarioServidor.dbcVinculoEnter(Sender : TObject);
begin
	getNomeVinculo;
end;

procedure TfrmCadFuncionarioServidor.DBNavigator1Click(Sender : TObject; Button : TNavigateBtn);
begin
	getFuncionario;
	getNomeEmpresa;
	getNomeServidor;
	getNomeVinculo;
end;

procedure TfrmCadFuncionarioServidor.validaCampos;
var
	oCDS_Aux : TClientDataSet;
begin
	oCDS_Aux := TClientDataSet.Create(nil);

	if dbcFuncionario.Text = '' then
	begin
		p_MsgAviso('Funcionário é obrigatório');
		Abort;
	end;
	if dbcEmpresa.Text = '' then
	begin
		p_MsgAviso('Empresa é obrigatória');
		Abort;
	end;
	if dbcServidor.Text = '' then
	begin
		p_MsgAviso('Tipo servidor é obrigatório');
		Abort;
	end;
	if dbcVinculo.Text = '' then
	begin
		p_MsgAviso('Tipo vinculo é obrigatório');
		Abort;
	end;
	if dbcDescPatronal.Text = '' then
	begin
		p_MsgAviso('Desconto patronal é obrigatório');
		Abort;
	end;
	if dbcDescFunc.Text = '' then
	begin
		p_MsgAviso('Desconto funcionário é obrigatório');
		Abort;
	end;

	if tableFuncionarioServidor.State in [dsEdit] then
	begin
		dmDados.ExecSQL('	SELECT cd_funcionario FROM FuncionarioSituacaoServidor WHERE cd_funcionario = ' + dbcFuncionario.Text +
				' AND cd_empresa = ' + dbcEmpresa.Text +
				' AND cd_empresa <> ' + IntToStr(tableFuncionarioServidor.Fields[1].OldValue), oCDS_Aux);
		if not oCDS_Aux.IsEmpty then
		begin
			p_MsgAviso('Funcionário informado já existe cadastro');
			Abort;
		end;
	end;

	if tableFuncionarioServidor.State in [dsInsert] then
	begin
		dmDados.ExecSQL(' SELECT cd_funcionario FROM FuncionarioSituacaoServidor WHERE cd_funcionario = ' + dbcFuncionario.Text +
				' AND cd_empresa = ' + dbcEmpresa.Text, oCDS_Aux);
		if not oCDS_Aux.IsEmpty then
		begin
			p_MsgAviso('Funcionário informado já existe cadastro');
			Abort;
		end;
	end;

	oCDS_Aux.Free;
end;

procedure TfrmCadFuncionarioServidor.tableFuncionarioServidorBeforeDelete(DataSet : TDataSet);
begin
	if not f_MsgConfirma('Eliminar o Registro?') then
		Abort
end;

procedure TfrmCadFuncionarioServidor.tableFuncionarioServidorBeforePost(DataSet : TDataSet);
begin
	validaCampos;
end;

procedure TfrmCadFuncionarioServidor.SpeedButton2Click(Sender : TObject);
begin
	Close;
end;

end.
