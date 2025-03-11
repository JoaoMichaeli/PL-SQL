SET SERVEROUTPUT ON;

// Laços de repetições

// LOOP
DECLARE
    v_contador NUMBER(2) := 1;
BEGIN
    LOOP
        dbms_output.put_line(v_contador);
        v_contador := v_contador + 1;
        EXIT WHEN v_contador > 20;
    END LOOP;
END;


// WHILE
DECLARE
    v_contador NUMBER(2) := 1;
BEGIN
    WHILE v_contador <= 20 LOOP
        dbms_output.put_line(v_contador);
        v_contador := v_contador + 1;
    END LOOP;
END;


// FOR
BEGIN
    FOR v_contador IN 1..20 LOOP
        dbms_output.put_line(v_contador);
    END LOOP;
END;

// exercícios

// 1 - Montar um bloco de programação que realize o processamento de uma tabuada qualquer, por exemplo a tabuada do número 150.

DECLARE
    v_numero NUMBER := &numero;
BEGIN
    FOR tabuada IN 1..10 LOOP
        dbms_output.put_line(tabuada * v_numero);
    END LOOP;
END;


// 2 - Em um intervalo numérico inteiro, informar quantos números são pares e quantos são impares
DECLARE
    impares NUMBER := 0;
    pares   NUMBER := 0;
BEGIN
    FOR x IN 1..1357 LOOP
        IF MOD(x, 2) = 0 THEN
            pares := pares + 1;
        ELSE
            impares := impares + 1;
        END IF;
    END LOOP;

    dbms_output.put_line('A quantidade de número pares são: ' || pares);
    dbms_output.put_line('A quantidade de número impares são: ' || impares);
END;


// 3 - Exibir a média dos valores pares em um intervalo numerico e soma dos impares

DECLARE
    impar   NUMBER := 0;
    s_impar NUMBER := 0;
    par     NUMBER := 0;
    m_par   NUMBER := 0;
BEGIN
    FOR x IN 1..150 LOOP
        IF MOD(x, 2) = 0 THEN
            par := par + 1;
            m_par := m_par + x;
        ELSE
            impar := impar + 1;
            s_impar := s_impar + x;
        END IF;
    END LOOP;

    m_par := m_par / par;
    s_impar := s_impar + x;
    dbms_output.put_line('A média dos valores pares são: ' || m_par);
    dbms_output.put_line('A soma dos valores impares são: ' || s_impar);
END;