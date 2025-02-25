set SERVEROUTPUT on;

DECLARE
    genero CHAR(1) := '&digite';
BEGIN
    IF upper(genero) = 'M' THEN
        dbms_output.put_line('O gen�ro informado � Masculino');
    ELSIF upper(genero) = 'F' THEN
        dbms_output.put_line('O gen�ro informado � Feminio');
    ELSE
        dbms_output.put_line('Outros');
    END IF;
END;

// 1 - Criar um bloco an�nimo para informar se o n�mero informado � par ou �mpar
DECLARE
    numero NUMBER := '&digite';
BEGIN
    IF MOD(numero,2) = 0 THEN
        dbms_output.put_line('O n�mero informado � PAR');
    ELSE
        dbms_output.put_line('O n�mero informado � �MPAR');
    END IF;
END;

/*
2 - Criar um bloco an�nimo para informar o usu�rio se a nota esta acima da m�dia, na m�dia ou reprovado
* Acima de 8 e menor que 10 = nota acima da m�dia!
* Entre 6 e 7 = nota na m�dia!
* Menor que 6 = reprovado!
*/
DECLARE
    nota DOUBLE := '&digite';
BEGIN
    IF nota >= 8 AND nota <= 10 THEN
        dbms_output.put_line('A nota est� acima da m�dia');
    ELSIF nota BETWEEN 6 AND 7 THEN
        dbms_output.put_line('A nota est� na m�dia');
    ELSE
        dbms_output.put_line('Voc� foi reprovado');
    END IF;
END;
