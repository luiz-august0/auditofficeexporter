unit mCreateTables;

interface

procedure pCriaTabelas;

implementation

uses
	oDmDados;

procedure pCriaTabelas;
begin
	try
		dmDados.ExecSQL('CREATE TABLE ClassificacaoTce(classificacao_tce VARCHAR(20) PRIMARY KEY, descricao_tce VARCHAR(255) NOT NULL)', nil);
	except
	end;
	try
		dmDados.ExecSQL(' CREATE TABLE ClassificacaoXTce( ' + 
				' classificacao_sistema VARCHAR(20) NOT NULL, ' + 
				' classificacao_tce VARCHAR(20) NOT NULL, ' +
				' PRIMARY KEY(classificacao_sistema, classificacao_tce)) ', nil);

		dmDados.ExecSQL(' ALTER TABLE ClassificacaoXTce ADD CONSTRAINT fk_classificacao_tce ' +
				' FOREIGN KEY (classificacao_tce) REFERENCES ClassificacaoTce (classificacao_tce) ', nil);
	except
	end;
	try
		dmDados.ExecSQL('CREATE TABLE TiposFuncionario(tipo_codigo INT PRIMARY KEY, tipo_descricao VARCHAR(80) NOT NULL)', nil);

		dmDados.ExecSQL(' INSERT INTO Tiposfuncionario VALUES ' + 
				' (1,"Estatutário efetivo"), ' +
				' (2,"Celetista ocupante de emprego público"), ' + 
				' (3,"Temporário com vínculo CLT"), ' + 
				' (4,"Temporário com vínculo administrativo"), ' + 
				' (5,"Comissionado puro"), ' + 
				' (6,"Estatutário ocupante de cargo em comissão"), ' + 
				' (7,"Celetista ocupante de cargo em comissão"), ' + 
				' (8,"Recepcionado de outra entidade"), ' + 
				' (9,"Cedido com ônus para origem"), ' + 
				' (10,"Estagiário"), ' + 
				' (11,"Jovem aprendiz"), ' + 
				' (12,"Agente Político"), ' + 
				' (13,"Conselheiro Tutelar"), ' + 
				' (14,"Outro Conselheiro"), ' + 
				' (15,"Celetista ocupante de cargo efetivo")', nil);
	except
	end;
	try
		dmDados.ExecSQL('CREATE TABLE TiposVinculoFuncionario(vinculo_codigo INT PRIMARY KEY, descricao VARCHAR(55) NOT NULL)', nil);

		dmDados.ExecSQL(' INSERT INTO TiposVinculoFuncionario VALUES ' + 
				' (1,"Tesouro"), ' +
				' (2,"RPPS (Sem Segregação)"), ' + 
				' (3,"Fundo Previdenciário"), ' + 
				' (4,"Fundo Financeiro"), ' + 
				' (5,"Fundo Militar"), ' + 
				' (6,"Outro Fundo"), ' + 
				' (7,"RGPS")', nil);
	except
	end;
	try
		dmDados.ExecSQL('CREATE TABLE DescontosFuncionario(Desc_Patronal FLOAT,Desc_Func FLOAT)', nil);

		dmDados.ExecSQL(' INSERT INTO DescontosFuncionario VALUES ' + 
				' (30.21, 9.0), ' +
				' (30.21, 11.0), ' + 
				' (30.21, 8.0), ' + 
				' (00.00, 00.0) ', nil);
	except
	end;
	try
		dmDados.ExecSQL(' CREATE TABLE FuncionarioSituacaoServidor( ' + 
				' cd_funcionario INT NOT NULL, ' + 
				' cd_empresa INT NOT NULL, ' + 
				' tipo_codigo INT NOT NULL, ' +
				' vinculo_codigo INT NOT NULL, ' + 
				' Desc_Patronal FLOAT NOT NULL, ' + 
				' Desc_Func FLOAT NOT NULL) ', nil);

		dmDados.ExecSQL('ALTER TABLE FuncionarioSituacaoServidor ADD CONSTRAINT pk_empresa_funcionario PRIMARY KEY (cd_funcionario, cd_empresa)', nil);
		dmDados.ExecSQL('ALTER TABLE FuncionarioSituacaoServidor ADD CONSTRAINT fk_tipo_codigo FOREIGN KEY (tipo_codigo) REFERENCES TiposFuncionario (tipo_codigo)', nil);
		dmDados.ExecSQL('ALTER TABLE FuncionarioSituacaoServidor ADD CONSTRAINT fk_vinculo_codigo FOREIGN KEY (vinculo_codigo) REFERENCES TiposVinculoFuncionario (vinculo_codigo)', nil);
	except
	end;
	try
		dmDados.ExecSQL('CREATE TABLE HistoricoExpCampanha(campanha_cod VARCHAR(50) NOT NULL)', nil);
	except
	end;
	try
		dmDados.ExecSQL('CREATE TABLE TipoMovimentoContabil(colunaP INT PRIMARY KEY,descricao VARCHAR(55) NOT NULL)', nil);

		dmDados.ExecSQL(' INSERT INTO TipoMovimentoContabil VALUES ' + 
				' (1, "Abertura do Exercício"), ' +
				' (2, "Movimento Normal"), ' + 
				' (3, "Encerramento do Exercício") ', nil);
	except
	end;
	try
		dmDados.ExecSQL('CREATE TABLE IdentificadorSuperavit(colunaQ INT PRIMARY KEY, descricao VARCHAR(55) NOT NULL)', nil);

		dmDados.ExecSQL(' INSERT INTO IdentificadorSuperavit VALUES ' + 
				' (1, "Financeiro - F"), ' +
				' (2, "Permanente - P"), ' + 
				' (3, "Permanente - P - Dívida Fundada"), ' + 
				' (9, "Outros") ', nil);
	except
	end;
	try
		dmDados.ExecSQL('CREATE TABLE IdentificadorVariacaoPatrimonial(colunaR INT PRIMARY KEY,descricao VARCHAR(55) NOT NULL)', nil);

		dmDados.ExecSQL(' INSERT INTO IdentificadorVariacaoPatrimonial VALUES ' +
				' (1, "Incorporação de Ativo"), ' +
				' (2, "Desincorporação de Passivo"), ' + 
				' (3, "Incorporação de Passivo"), ' + 
				' (4, "Desincorporação de Ativo"), ' + 
				' (99, "Outros Registros Contábeis") ', nil);
	except
	end;
	try
		dmDados.ExecSQL('CREATE TABLE HistoricoExpMovimentoColunas(colunaP INT NOT NULL,colunaQ INT NOT NULL,colunaR INT NOT NULL)', nil);

		dmDados.ExecSQL('ALTER TABLE HistoricoExpMovimentoColunas ADD CONSTRAINT fk_colunaP FOREIGN KEY (colunaP) REFERENCES TipoMovimentoContabil(colunaP)', nil);
		dmDados.ExecSQL('ALTER TABLE HistoricoExpMovimentoColunas ADD CONSTRAINT fk_colunaQ FOREIGN KEY (colunaQ) REFERENCES IdentificadorSuperavit(colunaQ)', nil);
		dmDados.ExecSQL('ALTER TABLE HistoricoExpMovimentoColunas ADD CONSTRAINT fk_colunaR FOREIGN KEY (colunaR) REFERENCES IdentificadorVariacaoPatrimonial(colunaR)', nil);
	except
	end;
  try
  	dmDados.ExecSQL('CREATE TABLE HistoricoExpFolhaLotacaoCPF(lotacao VARCHAR(80), cpf VARCHAR(11))',nil);
  except
  end;
end;

end.
