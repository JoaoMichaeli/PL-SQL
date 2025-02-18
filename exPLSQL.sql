SELECT
    a.nom_pais          pais,
    COUNT(b.nom_estado) "QTD ESTADO"
FROM
    rm555678.pais   a
    LEFT JOIN rm555678.estado b ON ( a.cod_pais = b.cod_pais )
GROUP BY
    a.nom_pais
HAVING
    COUNT(b.nom_estado) > 5;

----------------------------------------------------------

SELECT
    estado.nom_estado        estado,
    COUNT(cidade.nom_cidade) "QTD CIDADE"
FROM
    rm555678.estado
    LEFT JOIN cidade ON estado.cod_estado = cidade.cod_cidade
GROUP BY
    estado.nom_estado;

----------------------------------------------------------

SELECT
    a.nom_pais          pais,
    b.nom_estado        estado,
    COUNT(c.nom_cidade) "QDT CIDADES"
FROM
         rm555678.pais a
    JOIN rm555678.estado b ON ( a.cod_pais = b.cod_pais )
    LEFT JOIN rm555678.cidade c ON ( b.cod_estado = c.cod_estado )
GROUP BY
    a.nom_pais,
    b.nom_estado;
        
----------------------------------------------------------

--INTRODUÇÃO A BLOCO ANÔNIMO

SET SERVEROUTPUT ON;

DECLARE
    idade NUMBER;
    nome VARCHAR2(30) := 'VERGS';
    ende VARCHAR2(50) := '&ENDERECO'; -- & ler o teclado
BEGIN
    idade := 39;
    DBMS_OUTPUT.PUT_LINE('A idade informada é: ' || idade);
    DBMS_OUTPUT.PUT_LINE('O nome informado é: ' || nome);
    DBMS_OUTPUT.PUT_LINE('Endereço informado é: ' || ende); 
END;

----------------------------------------------------------

--EXERC 1 - Criar um bloco PL-SQL para calcular o valor do novo salário mínimo que deverá ser de 25% em cima do atual, que é de R$

DECLARE
    salarioMIN NUMBER;
    salarioNovo NUMBER;
BEGIN
    salariomin := 1518;
    salarionovo := salariomin * 1.25;
    DBMS_OUTPUT.PUT_LINE('O salario atual é: ' || salariomin);
    DBMS_OUTPUT.PUT_LINE('O salario novo é: ' || salarionovo);
END;


----------------------------------------------------------

--EXERC 2

DECLARE
 cambio NUMBER := '&CAMBIO';
 dolar NUMBER := 45;
 reais NUMBER;
BEGIN
    reais := dolar * cambio;
    DBMS_OUTPUT.PUT_LINE('O valor do cambio é: ' || cambio);
    DBMS_OUTPUT.PUT_LINE('O valor do dolar é: ' || dolar);
    DBMS_OUTPUT.PUT_LINE('O valor em reais é: ' || reais);
END;

----------------------------------------------------------

--EXERC 3

DECLARE
    valorComp FLOAT := '&VALOR';
    valorFinal DECIMAL(10,2);
BEGIN
    valorFinal := (valorComp * 1.03) / 10;
    DBMS_OUTPUT.PUT_LINE('O valor da compra: ' || valorcomp);
    DBMS_OUTPUT.PUT_LINE('O valor de cada parcela: ' || valorfinal);
    DBMS_OUTPUT.PUT_LINE('O valor total da compra: ' || valorfinal*10);
    
END;