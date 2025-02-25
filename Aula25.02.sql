set SERVEROUTPUT on;

DECLARE
    genero CHAR(1) := '&digite';
BEGIN
    IF upper(genero) = 'M' THEN
        dbms_output.put_line('O genêro informado é Masculino');
    ELSIF upper(genero) = 'F' THEN
        dbms_output.put_line('O genêro informado é Feminio');
    ELSE
        dbms_output.put_line('Outros');
    END IF;
END;

// 1 - Criar um bloco anônimo para informar se o número informado é par ou ímpar
DECLARE
    numero NUMBER := '&digite';
BEGIN
    IF MOD(numero, 2) = 0 THEN
        dbms_output.put_line('O número informado é PAR');
    ELSE
        dbms_output.put_line('O número informado é ÍMPAR');
    END IF;
END;

/*
2 - Criar um bloco anônimo para informar o usuário se a nota esta acima da média, na média ou reprovado
* Acima de 8 e menor que 10 = nota acima da média!
* Entre 6 e 7 = nota na média!
* Menor que 6 = reprovado!
*/
DECLARE
    nota NUMBER := &digite;
BEGIN
    IF
        nota >= 8
        AND nota <= 10
    THEN
        dbms_output.put_line('A nota está acima da média');
    ELSIF
        nota >= 6
        AND nota < 8
    THEN
        dbms_output.put_line('A nota está na média');
    ELSE
        dbms_output.put_line('Você foi reprovado');
    END IF;
END;

---------------------------------------------------------------------------------

// 3
CREATE TABLE aluno (
    ra   CHAR(9),
    nome VARCHAR2(50),
    CONSTRAINT aluno_pk PRIMARY KEY ( ra )
);

INSERT INTO aluno (ra,nome) VALUES ('111222333','Antonio Alves');
INSERT INTO aluno (ra,nome) VALUES ('222333444','Beatriz Bernandes');
INSERT INTO aluno (ra,nome) VALUES ('333444555','Cláudio Cardoso');


-- INSTRUÇÃO DQL, exemplo:
// Buscando o aluno pelo RA
DECLARE
    v_ra CHAR(9) := '333444555';
    v_nome VARCHAR2(50);
BEGIN
    SELECT nome INTO v_nome FROM aluno WHERE ra = v_ra;
    dbms_output.put_line('O nome do aluno é: ' || v_nome);
END;

// Inserção pelo RA e Nome
DECLARE
    v_ra CHAR(9) := '444555666';
    v_nome VARCHAR2(50) := 'Daniela Dorneles';
BEGIN
    INSERT INTO aluno (ra,nome) VALUES(v_ra, v_nome);
END;

// Atualizando o valor do banco com o dado da variante
DECLARE
    v_ra CHAR(9) := '111222333';
    v_nome VARCHAR2(50) := 'Antonio Rodrigues';
BEGIN
    UPDATE aluno SET nome = v_nome WHERE ra = v_ra;
END;

// Deletando
DECLARE
    v_ra CHAR(9) := '444555666';
BEGIN
    DELETE FROM aluno WHERE ra = v_ra;
END;