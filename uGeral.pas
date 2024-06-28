unit uGeral;

interface

uses
	Classes,
	Controls,
	Dialogs,
	Windows,
	Forms,
	SysUtils,
	DB,
	DBClient,
	MaskUtils;

type
	TSQLParam = array of String;
	TSQLParType = array of String;

function f_MsgConfirma(Msg : string) : Boolean;
procedure p_MsgAviso(Msg : string);
procedure p_MsgErro(Msg : string);
function f_StrToSQL(Str : string) : string;
function f_IntToSQL(Valor : double) : String;
function f_BoolToSQL(Vlr : Boolean) : String;
function f_DateToSQL(Data : TDateTime) : String;
function f_TimeToSQL(Hora : TDateTime) : String;
function VirgulaPorPonto(Vlr : string) : string;
function PontoPorVirgula(Vlr : string) : string;
function f_RoundTwoDec(Value : double; const vbArred : Boolean = False) : double;
function tbKeyIsDown(const Key : integer) : Boolean;
procedure pGravaTXT(content, name : String);
function fExtraisNumeros(s : string) : String;
function fTrataTelefone(Str : String) : String;
function fTrataTexto(Str : String) : String;
function fGeraSigla(Str : String) : String;
function fGetContentFile(caminho : String) : String;
function fTrataCEP(cep : String) : String;
function fTrataCPFCNPJ(Str : String) : String;
function fRemoveAspas(Str : String) : String;
function FormatarCodBar(Texto : string; TamanhoDesejado : integer; AcrescentarADireita : Boolean = true; CaracterAcrescentar : String = ' ') : string;
function Ceil(X : Extended) : integer;
function GetDvEAN13(aCode : string) : Byte;
function f_TiraMascara(Str : string) : string;
function f_ValidaCPF(s_CPF : string; const bShowErro : Boolean = true) : Boolean;
function UltimoDiaDoMes( MesAno: string ): string;

implementation

function f_MsgConfirma(Msg : string) : Boolean;
var
	tex : ^PChar;
begin
	tex    := @Msg;
	Result := (MessageBox(Application.Handle, tex^, 'Pergunta', mb_yesno + mb_iconquestion + MB_TOPMOST) = 6);
end;

// ******************************************************************************
procedure p_MsgAviso(Msg : string);
var
	tex : ^PChar;
begin
	tex           := @Msg;
	Screen.Cursor := crDefault;
	MessageBox(Application.Handle, tex^, 'Aviso', mb_ok + mb_iconwarning + MB_TOPMOST);
end;

// ******************************************************************************
procedure p_MsgErro(Msg : string);
var
	tex : ^PChar;
begin
	tex           := @Msg;
	Screen.Cursor := crDefault;
	MessageBox(Application.Handle, tex^, 'Erro', mb_ok + mb_iconerror + MB_TOPMOST);
end;

// ******************************************************************************
function f_StrToSQL(Str : String) : String;
begin
	if Str <> '' then
		Result := #39 + Str + #39
	else
		Result := 'NULL';
end;

// ******************************************************************************
function tbKeyIsDown(const Key : integer) : Boolean;
begin
	Result := GetKeyState(Key) and 128 > 0;
end;

// ******************************************************************************
function f_IntToSQL(Valor : double) : String;
begin
	if Valor <> 0 then
		Result := FormatFloat('0', Valor)
	else
		Result := 'NULL';
end;

// ******************************************************************************
function f_BoolToSQL(Vlr : Boolean) : String;
begin
	if Vlr then
		Result := #39'S'#39
	else
		Result := #39'N'#39

end;

// ******************************************************************************
function f_DateToSQL(Data : TDateTime) : String;
begin
	Result := 'NULL';
	if Data <> 0 then
	begin
		Result := #39 + FormatDateTime('yyyymmdd', Data) + #39
	end;
end;

// ******************************************************************************
function f_TimeToSQL(Hora : TDateTime) : String;
begin
	Result := 'NULL';
	if Hora <> 0 then
		Result := #39 + FormatDateTime('hh:nn:ss', Hora) + #39;
end;

// ******************************************************************************
function VirgulaPorPonto(Vlr : string) : string;
var
	i   : integer;
	Str : string;
begin
	Str := Vlr;

	if (Str = '') then
		Result := '0'
	else
	begin
		if Pos(',', Str) > 0 then
		begin
			for i := 1 to 2 do
				if Pos('.', Str) > 0 then
					Delete(Str, Pos('.', Str), 1);

			if Pos(',', Str) > 0 then
				Str[Pos(',', Str)] := '.';

			Result := Str;
		end
		else
			Result := Str;
	end;
end;

// ******************************************************************************
function PontoPorVirgula(Vlr : string) : string;
var
	i   : integer;
	Str : string;
begin
	Str := Vlr;

	if (Str = '') then
		Result := '0'
	else
	begin
		if Pos('.', Str) > 0 then
		begin
			for i := 1 to 2 do
				if Pos(',', Str) > 0 then
					Delete(Str, Pos(',', Str), 1);

			if Pos('.', Str) > 0 then
				Str[Pos('.', Str)] := ',';

			Result := Str;
		end
		else
			Result := Str;
	end;
end;

// ******************************************************************************
function f_RoundTwoDec(Value : double; const vbArred : Boolean) : double;
// Result := StrToFloat( FormatFloat( '0.00', Value ));
var
	Resultado : double;
begin
	try
		if (vbArred) then
		begin
			Resultado := StrToFloat(FormatFloat('0.00000', Value));
			Resultado := StrToFloat(FormatFloat('0.0000', Resultado));
			Resultado := StrToFloat(FormatFloat('0.000', Resultado));
			if StrToFloat(Copy(FloatToStr(Resultado), Length(FloatToStr(Resultado)), Length(FloatToStr(Resultado)))) >= 5 then
			begin
				Resultado := StrToFloat(FormatFloat('0.00', Resultado + 0.001));
			end
			else
				Resultado := StrToFloat(FormatFloat('0.00', Resultado));
		end else
		begin
			Resultado := StrToFloat(FormatFloat('0.00', Value * 100));
			Resultado := Trunc(Resultado) / 100;
		end;

	except
		Resultado := StrToFloat(FormatFloat('0.00000', Value));
		Resultado := StrToFloat(FormatFloat('0.0000', Resultado));
		Resultado := StrToFloat(FormatFloat('0.000', Resultado));
		if StrToFloat(Copy(FloatToStr(Resultado), Length(FloatToStr(Resultado)), Length(FloatToStr(Resultado)))) >= 5 then
		begin
			Resultado := StrToFloat(FormatFloat('0.00', Resultado + 0.001));
		end
		else
			Resultado := StrToFloat(FormatFloat('0.00', Resultado));
	end;

	Result := Resultado;
end;

// ******************************************************************************
procedure pGravaTXT(content, name : String);
var
	arq : TextFile;
begin
	AssignFile(arq, name);
	Rewrite(arq);
	Write(arq, content);
	CloseFile(arq);
end;

// ******************************************************************************
function fExtraisNumeros(s : string) : String;
var
	i : integer;
begin
	Result := '';
	for i  := 1 to Length(s) do
	begin
		if (i <= Length(s)) and (s[i] in ['0' .. '9']) then
			Result := Result + s[i];
	end;
end;

// ******************************************************************************
function fTrataTelefone(Str : String) : String;
begin
	Str    := fExtraisNumeros(Str);
	Str    := Trim(Copy(Str, Length(Str) - 7, Length(Str)));
	Result := '';
	if Length(Str) = 8 then
		Result := FormatMaskText('00000000;0;_', Str);
end;

// ******************************************************************************
function fTrataTexto(Str : String) : String;
begin
	Result := Str;
	Result := StringReplace(Result, #39, ' ', [rfReplaceAll, rfIgnoreCase]);
end;

// ******************************************************************************
function fGeraSigla(Str : String) : String;
var
	i    : integer;
	vbFW : Boolean;
begin
	Str    := Trim(Str);
	Result := '';
	vbFW   := true;
	for i  := 0 to Length(Str) do
	begin
		if vbFW then
			Result := Result + Trim(Str[i]);
		vbFW     := Str[i] = ' ';
	end;
end;

// ******************************************************************************
function fGetContentFile(caminho : String) : String;
var
	oSL_Content : TStringList;
begin
	Result := '';
	if not FileExists(caminho) then
		Exit;
	oSL_Content := TStringList.Create;
	oSL_Content.LoadFromFile(caminho);
	Result := oSL_Content.Text;
	Result := StringReplace(Result, #39 + 'ï»¿', '', [rfReplaceAll]);
	Result := StringReplace(Result, #39 + '#$D#$A' + #39, '', [rfReplaceAll]);
	Result := StringReplace(Result, '#$D#$A', '', [rfReplaceAll]);
	Result := StringReplace(Result, #39#$D#$A#39, '', [rfReplaceAll]);
	Result := StringReplace(Result, '#$D#$A', ' ', [rfReplaceAll]);
	Result := StringReplace(Result, #$D#$A, ' ', [rfReplaceAll]);
	Result := StringReplace(Result, 'ï»¿', '', [rfReplaceAll]);
	Result := StringReplace(Result, #9, ' ', [rfReplaceAll]);

	// Result := StringReplace(Result, 'FROM ', ' FROM', [rfReplaceAll]);
	oSL_Content.Free;
end;

// ******************************************************************************
function fTrataCEP(cep : String) : String;
begin
	cep    := StringReplace(cep, '-', '', [rfReplaceAll]);
	cep    := StringReplace(cep, '.', '', [rfReplaceAll]);
	Result := '';
	if Length(cep) = 8 then
		Result := FormatMaskText('00000000;0;_', cep);
end;

// ******************************************************************************
function fTrataCPFCNPJ(Str : String) : String;
begin
	Result := Str;
	Result := StringReplace(Result, '.', '', [rfReplaceAll]);
	Result := StringReplace(Result, '/', '', [rfReplaceAll]);
	Result := StringReplace(Result, '-', '', [rfReplaceAll]);
	if not (Length(Result) in [11, 14]) then
		Result := '';
end;

// ******************************************************************************
function fRemoveAspas(Str : String) : String;
begin
	Result := StringReplace(StringReplace(Str, Chr(34), ' ', [rfReplaceAll]), Chr(39), ' ', [rfReplaceAll]);
end;

// ******************************************************************************
function FormatarCodBar(Texto : string; TamanhoDesejado : integer; AcrescentarADireita : Boolean = true; CaracterAcrescentar : String = ' ') : string;
{
	OBJETIVO: Eliminar caracteres inválidos e acrescentar caracteres à esquerda ou à direita do texto original para que a string resultante fique com o tamanho desejado

	Texto : Texto original
	TamanhoDesejado: Tamanho que a string resultante deverá ter
	AcrescentarADireita: Indica se o carácter será acrescentado à direita ou à esquerda
	TRUE - Se o tamanho do texto for MENOR que o desejado, acrescentar carácter à direita
	Se o tamanho do texto for MAIOR que o desejado, eliminar últimos caracteres do texto
	FALSE - Se o tamanho do texto for MENOR que o desejado, acrescentar carácter à esquerda
	Se o tamanho do texto for MAIOR que o desejado, eliminar primeiros caracteres do texto
	CaracterAcrescentar: Carácter que deverá ser acrescentado
}
var
	QuantidadeAcrescentar,
		TamanhoTexto,
		PosicaoInicial,
		i : integer;

begin
	case CaracterAcrescentar[1] of
		'0' .. '9', 'a' .. 'z', 'A' .. 'Z' :
			; { Não faz nada }
		else
			CaracterAcrescentar := ' ';
	end;

	Texto        := Trim(AnsiUpperCase(Texto));
	TamanhoTexto := Length(Texto);
	for i        := 1 to (TamanhoTexto) do
	begin
		if Pos(Texto[i], ' 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`~''"!@#$%^&*()_-+=|/\{}[]:;,.<>') = 0 then
		begin
			case Texto[i] of
				'Á', 'À', 'Â', 'Ä', 'Ã' :
					Texto[i] := 'A';
				'É', 'È', 'Ê', 'Ë' :
					Texto[i] := 'E';
				'Í', 'Ì', 'Î', 'Ï' :
					Texto[i] := 'I';
				'Ó', 'Ò', 'Ô', 'Ö', 'Õ' :
					Texto[i] := 'O';
				'Ú', 'Ù', 'Û', 'Ü' :
					Texto[i] := 'U';
				'Ç' :
					Texto[i] := 'C';
				'Ñ' :
					Texto[i] := 'N';
				else
					Texto[i] := ' ';
			end;
		end;
	end;

	QuantidadeAcrescentar := TamanhoDesejado - TamanhoTexto;
	if QuantidadeAcrescentar < 0 then
		QuantidadeAcrescentar := 0;
	if CaracterAcrescentar = '' then
		CaracterAcrescentar := ' ';
	if TamanhoTexto >= TamanhoDesejado then
		PosicaoInicial := TamanhoTexto - TamanhoDesejado + 1
	else
		PosicaoInicial := 1;

	if AcrescentarADireita then
		Texto := Copy(Texto, 1, TamanhoDesejado) + StringOfChar(CaracterAcrescentar[1], QuantidadeAcrescentar)
	else
		Texto := StringOfChar(CaracterAcrescentar[1], QuantidadeAcrescentar) + Copy(Texto, PosicaoInicial, TamanhoDesejado);

	Result := AnsiUpperCase(Texto);
end;

// ******************************************************************************
function Ceil(X : Extended) : integer;
begin
	Result := (Trunc(X));
	if Frac(X) > 0 then
		Inc(Result);
end;

// ******************************************************************************
function GetDvEAN13(aCode : string) : Byte;
var
	iCode : array [0 .. 11] of Byte;
	i     : Byte;
begin
	Result         := 0;
	for i          := 1 to 12 do
		iCode[i - 1] := StrToInt(aCode[i]);

	for i    := 0 to 11 do
		Result := Result + iCode[i] * ((i mod 2) * 2 + 1);

	Result := ((Ceil(Result / 10) * 10) - Result);
end;

function f_TiraMascara(Str : string) : string;
var
	Aux : string;
	i   : integer;
begin
	Str := UpperCase(Trim(Str));

	if (Str <> '') then
		for i := 1 to Length(Str) do
			if (Str[i] in ['0' .. '9', 'A' .. 'Z']) then
				Aux := Aux + Str[i];

	Result := Aux;
end;

function f_ValidaCPF(s_CPF : string; const bShowErro : Boolean = true) : Boolean;
var
	localCPF       : string;
	localResult    : Boolean;
	digit1, digit2 : integer;
	ii, soma       : integer;
begin
	localCPF    := '';
	localResult := False;

	// ** analisa CPF no formato 999.999.999-00 **//
	if Length(s_CPF) = 14 then
	begin
		if (Copy(s_CPF, 4, 1) + Copy(s_CPF, 8, 1) + Copy(s_CPF, 12, 1) = '..-') then
		begin
			localCPF    := Copy(s_CPF, 1, 3) + Copy(s_CPF, 5, 3) + Copy(s_CPF, 9, 3) + Copy(s_CPF, 13, 2);
			localResult := true;
		end;
	end;

	// ** analisa CPF no formato 99999999900 **//
	if Length(s_CPF) = 11 then
	begin
		localCPF    := s_CPF;
		localResult := true;
	end;

	// ** comeca a verificacao do digito **//
	if localResult then
	begin
		try
			// ** 1° digito **//
			soma   := 0;
			for ii := 1 to 9 do
				inc(soma, StrToInt(Copy(localCPF, 10 - ii, 1)) * (ii + 1));
			digit1 := 11 - (soma mod 11);
			if digit1 > 9 then
				digit1 := 0;

			// ** 2° digito **//
			soma   := 0;
			for ii := 1 to 10 do
				inc(soma, StrToInt(Copy(localCPF, 11 - ii, 1)) * (ii + 1));
			digit2 := 11 - (soma mod 11);
			if digit2 > 9 then
				digit2 := 0;

			// ** Checa os dois dígitos **//
			if (digit1 = StrToInt(Copy(localCPF, 10, 1))) and (digit2 = StrToInt(Copy(localCPF, 11, 1))) then
				localResult := true
			else
				localResult := False;
		except
			localResult := False;
		end;
	end;

	if not localResult then
	begin
		if (bShowErro) then
			p_MsgErro('O número do CPF é inválido.');
	end;

	Result := localResult;

end;

function UltimoDiaDoMes( MesAno: string ): string;
var
  sMes: string;
  sAno: string;
begin
  sMes := Copy( MesAno, 1, 2 );
  sAno := Copy( MesAno, 4, 2 );
  if Pos( sMes, '01 03 05 07 08 10 12' ) > 0 then
    UltimoDiaDoMes := '31'
  else
    if sMes <> '02' then
      UltimoDiaDoMes := '30'
    else
      if ( StrToInt( sAno ) mod 4 ) = 0 then
        UltimoDiaDoMes := '29'
      else
        UltimoDiaDoMes := '28';
end;

// ******************************************************************************
end.
