unit oDmDados;

interface

uses
	midas,
	midaslib,
	System.SysUtils,
	System.Classes,
	ZAbstractConnection,
	ZConnection,
	Data.DB,
	Forms,
	Dialogs,
	Data.Win.ADODB,
	FireDAC.Phys.MSAccDef,
	FireDAC.Stan.Intf,
	FireDAC.Phys,
	FireDAC.Phys.ODBCBase,
	FireDAC.Phys.MSAcc,
	ZAbstractRODataset,
	ZAbstractDataset,
	ZDataset,
	FireDAC.Stan.Option,
	FireDAC.Stan.Param,
	FireDAC.Stan.Error,
	FireDAC.DatS,
	FireDAC.Phys.Intf,
	FireDAC.DApt.Intf,
	FireDAC.Stan.Async,
	FireDAC.DApt,
	FireDAC.Comp.DataSet,
	FireDAC.Comp.Client,
	Datasnap.Provider,
	uGeral,
	AnsiStringReplaceJOHIA32Unit12,
	Datasnap.DBClient, ZAbstractTable;

type
	TdmDados = class(TDataModule)
		ZConnection : TZConnection;
		ZQuery : TZQuery;
		ClientDataSet1 : TClientDataSet;
		DataSetProvider : TDataSetProvider;
		private
			{ Private declarations }
		public
			vbConectado : Boolean;
			vsSQL       : String;
			procedure pConecta(vsHostName, vsUser, vsPassword, vsDatabase : String; viPort : Integer);
    	procedure pDesconecta;
			function AjustaSQL(SQL : Widestring) : Widestring;
			function ExecSQL(strSQL : string; const oClientDS : TClientDataSet = nil; const vaParams : TSQLParam = nil;
				const veParTypes : TSQLParType = nil) : Boolean;
			function DBGetProxCodigo(vsTabela, vsCampo, vsCondicao : String) : Integer;
	end;

var
	dmDados : TdmDados;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}


procedure TdmDados.pConecta(vsHostName, vsUser, vsPassword, vsDatabase : String; viPort : Integer);
begin
	if vbConectado then
		Exit;

	with ZConnection do
	begin
		ZConnection.Connected   := False;
		ZConnection.LoginPrompt := False;

		ZConnection.HostName := vsHostName;
		ZConnection.User     := vsUser;
		ZConnection.Password := vsPassword;
		ZConnection.Database := vsDatabase;
		ZConnection.Port     := viPort;

		try
			ZConnection.Connected   := True;
			DataSetProvider.DataSet := ZQuery;
      vbConectado := True;
		except
			on E : Exception do
			begin
				E.Message := 'SQL Server: Erro ao conectar!'#13#10'- ' + E.Message + #13#10 + vsHostName + ':' + vsDatabase;
				Raise;
			end;
		end;
	end;
end;

procedure TdmDados.pDesconecta;
begin
  ZConnection.Connected := False;
  vbConectado := False;
end;

function TdmDados.AjustaSQL(SQL : Widestring) : Widestring;
var
	Aux,
  SQLfim : string;
begin
	SQLfim := SQL;

	// Aux := StringReplace(SQL, '\', '\\', [rfReplaceAll, rfIgnoreCase]);
	Aux := StringReplace_JOH_IA32_12(SQL, '\', '\\', [rfReplaceAll, rfIgnoreCase]);
	if Aux <> '' then
		SQLfim := Aux;

	// ** Substitui todas as ASPAS (") por Apostrofos (')
	// SQLfim := StringReplace( SQLfim , #34 , #39 , [ rfReplaceAll , rfIgnoreCase ] );
	SQLfim := StringReplace_JOH_IA32_12(SQLfim, #34, #39, [rfReplaceAll, rfIgnoreCase]);

	Result := SQLfim;
end;

function TdmDados.ExecSQL(strSQL : string; const oClientDS : TClientDataSet; const vaParams : TSQLParam;
	const veParTypes : TSQLParType) : Boolean;
var
	i : Integer;
	vs_SQL,
  vsMsgErro : String; // ** Comando SQL
	os_Params   : TStringList;
begin
	Result := False;

	vs_SQL := Trim(strSQL);

	if vs_SQL = '' then
		Exit;

	// ** Verifica se o comando SQL possui parametros
	// Parametros sao usados apenas para o caso de campos MEMO
	// Cada parametro deve ser precedido pelo caracter '§' (mais um no final).
	os_Params := nil;
	if Length(vaParams) > 0 then
	begin
		os_Params := TStringList.Create;
		for i     := Low(vaParams) to High(vaParams) do
			os_Params.Add(vaParams[i]);
	end;

	try
		with ZQuery do
		begin
			Close;
			ZQuery.SQL.Clear;
			ZQuery.SQL.Add(AjustaSQL(vs_SQL));
			if Assigned(os_Params) then
			begin
				ZQuery.Fields.Clear;
				for i := 0 to ZQuery.Params.Count - 1 do
				begin
					if veParTypes[i] = 'M' then
						ZQuery.Params[i].DataType := ftMemo
					else
						if veParTypes[i] = 'I' then
					begin
						ZQuery.FieldDefs.Add('Imagem', ftBlob);
						ZQuery.Params[i].DataType := ftBlob;
						// ZQuery.Params.ParamByName('Imagem').LoadFromStream(os_Params[ i ], ftBlob);
						ZQuery.Params[i].LoadFromFile(os_Params[i], ftBlob);
					end
					else
						ZQuery.Params[i].DataType := ftString;

					ZQuery.Params[i].ParamType := ptInput;

					if veParTypes[i] <> 'I' then
						ZQuery.Params[i].Value := os_Params[i];
				end;
				os_Params.Free;
			end;

			// ** Verifica se o comando SQL eh um SELECT (ha retorno de dados)
			if (Pos('SELECT', Trim(UpperCase(vs_SQL))) in [1, 2]) or
				(Pos('SHOW', Trim(UpperCase(vs_SQL))) = 1) then // ** Dados internos do Mysql (para programa de backup)
			begin
				Open;

				if oClientDS <> nil then
				begin
					with oClientDS do
					begin
						Close;
						// ** Limpa os campos estaticos declarados no ClientDS
						// - Necessario para compatibilidade ACCESS e INTERBASE
						// onde os Fields criados dinamicamente podem ser de
						// tipos diferentes (Ex: TStringField -> TWideStringField)
						Fields.Clear;
						SetProvider(DataSetProvider);
						Open;
						ProviderName := '';
					end;
				end;
			end
			else
				// ** Executa SQL quando nao ha retorno de dados
				ZQuery.ExecSQL;
		end;
		Result := True;

	except
		on E : Exception do
		begin

			vsMsgErro := '';
			if (Pos(UpperCase('CONNECT'), UpperCase(E.Message)) > 0) then
				vsMsgErro := 'Não foi possível conectar ao servidor(UNABLE TO CONNECT)!';
			if (Pos(UpperCase('SHUTDOWN'), UpperCase(E.Message)) > 0) then
				vsMsgErro := 'O servidor MySQL está sendo desligado(SERVER IN SHUTDOWN)!';
			E.Message   := '(ExecSQL): ' + vsMsgErro + ' ' + #13#10 + E.Message + #13#10 + vs_SQL;
			Raise;
		end;
	end;
end;

function TdmDados.DBGetProxCodigo(vsTabela, vsCampo, vsCondicao : String) : Integer;
var
	oCDS : TClientDataSet;
begin
	oCDS := TClientDataSet.Create(nil);
	try
		vsSQL := 'SELECT MAX(' + vsCampo + ') as Res FROM ' + vsTabela;
		if vsCondicao <> '' then
			vsSQL := vsSQL + ' WHERE ' + vsCondicao;
		ExecSQL(vsSQL, oCDS);
		Result := oCDS.FieldByName('Res').AsInteger + 1;
	finally
		FreeAndNil(oCDS);
	end;
end;

end.
