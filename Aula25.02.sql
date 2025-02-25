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
    IF MOD(numero,2) = 0 THEN
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
    nota DOUBLE := '&digite';
BEGIN
    IF nota >= 8 AND nota <= 10 THEN
        dbms_output.put_line('A nota está acima da média');
    ELSIF nota BETWEEN 6 AND 7 THEN
        dbms_output.put_line('A nota está na média');
    ELSE
        dbms_output.put_line('Você foi reprovado');
    END IF;
END;
