CREATE TABLE ClassificacaoTce(
	classificacao_tce VARCHAR(20) PRIMARY KEY,
	descricao_tce VARCHAR(255) NOT NULL
);

CREATE TABLE ClassificacaoXTce(
	classificacao_sistema VARCHAR(20) NOT NULL,
	classificacao_tce VARCHAR(20) NOT NULL,
	PRIMARY KEY(classificacao_sistema, classificacao_tce)
);

ALTER TABLE ClassificacaoXTce ADD CONSTRAINT fk_classificacao_tce
FOREIGN KEY (classificacao_tce) REFERENCES ClassificacaoTce (classificacao_tce);

CREATE TABLE TiposFuncionario(
	tipo_codigo INT PRIMARY KEY,
	tipo_descricao VARCHAR(80) NOT NULL
);

INSERT INTO Tiposfuncionario VALUES 
(1,'Estatut�rio efetivo'), 
(2,'Celetista ocupante de emprego p�blico'), 
(3,'Tempor�rio com v�nculo CLT'), 
(4,'Tempor�rio com v�nculo administrativo'),
(5,'Comissionado puro'),
(6,'Estatut�rio ocupante de cargo em comiss�o'),
(7,'Celetista ocupante de cargo em comiss�o'),
(8,'Recepcionado de outra entidade'),
(9,'Cedido com �nus para origem'),
(10,'Estagi�rio'),
(11,'Jovem aprendiz'),
(12,'Agente Pol�tico'),
(13,'Conselheiro Tutelar'),
(14,'Outro Conselheiro'),
(15,'Celetista ocupante de cargo efetivo');

CREATE TABLE TiposVinculoFuncionario(
	vinculo_codigo INT PRIMARY KEY,
	descricao VARCHAR(55) NOT NULL
);

INSERT INTO TiposVinculoFuncionario VALUES
(1,'Tesouro'),
(2,'RPPS (Sem Segrega��o)'),
(3,'Fundo Previdenci�rio'),
(4,'Fundo Financeiro'),
(5,'Fundo Militar'),
(6,'Outro Fundo'),
(7,'RGPS');


CREATE TABLE DescontosFuncionario(
	Desc_Patronal FLOAT,
	Desc_Func FLOAT
);

INSERT INTO DescontosFuncionario VALUES
(30.21, 9.0),
(30.21, 11.0),
(30.21, 8.0),
(00.00, 00.0);

CREATE TABLE FuncionarioSituacaoServidor(
	cd_funcionario INT NOT NULL,
	cd_empresa INT NOT NULL,
	tipo_codigo INT NOT NULL,
	vinculo_codigo INT NOT NULL,
	Desc_Patronal FLOAT NOT NULL,
	Desc_Func FLOAT NOT NULL
);

ALTER TABLE FuncionarioSituacaoServidor ADD CONSTRAINT pk_empresa_funcionario
PRIMARY KEY (cd_funcionario, cd_empresa);

ALTER TABLE FuncionarioSituacaoServidor ADD CONSTRAINT fk_tipo_codigo
FOREIGN KEY (tipo_codigo) REFERENCES TiposFuncionario (tipo_codigo);

ALTER TABLE FuncionarioSituacaoServidor ADD CONSTRAINT fk_vinculo_codigo
FOREIGN KEY (vinculo_codigo) REFERENCES TiposVinculoFuncionario (vinculo_codigo);

CREATE TABLE HistoricoExpCampanha(
	campanha_cod VARCHAR(50) NOT NULL
);

CREATE TABLE TipoMovimentoContabil(
	colunaP INT PRIMARY KEY,
	descricao VARCHAR(55) NOT NULL
);

INSERT INTO TipoMovimentoContabil VALUES
(1, 'Abertura do Exerc�cio'),
(2, 'Movimento Normal'),
(3, 'Encerramento do Exerc�cio');

CREATE TABLE IdentificadorSuperavit(
	colunaQ INT PRIMARY KEY,
	descricao VARCHAR(55) NOT NULL
);

INSERT INTO IdentificadorSuperavit VALUES
(1, 'Financeiro - "F"'),
(2, 'Permanente - "P"'),
(3, 'Permanente - "P" - D�vida Fundada'),
(9, 'Outros');

CREATE TABLE IdentificadorVariacaoPatrimonial(
	colunaR INT PRIMARY KEY,
	descricao VARCHAR(55) NOT NULL
);

INSERT INTO IdentificadorVariacaoPatrimonial VALUES
(1, 'Incorpora��o de Ativo'),
(2, 'Desincorpora��o de Passivo'),
(3, 'Incorpora��o de Passivo'),
(4, 'Desincorpora��o de Ativo'),
(99, 'Outros Registros Cont�beis');

CREATE TABLE HistoricoExpMovimentoColunas(
	colunaP INT NOT NULL,
	colunaQ INT NOT NULL,
	colunaR INT NOT NULL
);

ALTER TABLE HistoricoExpMovimentoColunas ADD CONSTRAINT fk_colunaP
FOREIGN KEY (colunaP) REFERENCES TipoMovimentoContabil(colunaP);

ALTER TABLE HistoricoExpMovimentoColunas ADD CONSTRAINT fk_colunaQ
FOREIGN KEY (colunaQ) REFERENCES IdentificadorSuperavit(colunaQ);

ALTER TABLE HistoricoExpMovimentoColunas ADD CONSTRAINT fk_colunaR
FOREIGN KEY (colunaR) REFERENCES IdentificadorVariacaoPatrimonial(colunaR);