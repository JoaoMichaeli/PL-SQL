CREATE TABLE clientes_aula (
    p_nome  VARCHAR2(30),
    p_email VARCHAR(30),
    idade   NUMBER
);

-------------- PACKAGE --------------

CREATE OR REPLACE PACKAGE pkg_aula_01 AS
    PROCEDURE adicionar_cliente (
        p_nome  VARCHAR2,
        p_email VARCHAR,
        idade   NUMBER
    );

    FUNCTION contar_clientes RETURN NUMBER;

END pkg_aula_01;


-------------- BODY --------------

CREATE OR REPLACE PACKAGE BODY pkg_aula_01 AS

    PROCEDURE adicionar_cliente (
        p_nome  VARCHAR2,
        p_email VARCHAR,
        idade   NUMBER
    ) IS
    BEGIN
        INSERT INTO clientes_aula VALUES ( p_nome,
                                           p_email,
                                           idade );

        COMMIT;
    END adicionar_cliente;

    FUNCTION contar_clientes RETURN NUMBER IS
        total_clientes NUMBER;
    BEGIN
        SELECT
            COUNT(1)
        INTO total_clientes
        FROM
            clientes_aula;

        RETURN total_clientes;
    END contar_clientes;

END pkg_aula_01;


-------------- CHAMANDO O PKG --------------

call pkg_aula_01.adicionar_cliente('João Victor', 'joaovictor_de_bem_@hotmail.com', 23);

SELECT pkg_aula_01.contar_clientes from dual;


-------------- EXERCICIO --------------

CREATE OR REPLACE PACKAGE pkg_produto AS
    PROCEDURE adicionar_produto (
        cod_produto NUMBER,
        nom_produto VARCHAR2,
        cod_barra VARCHAR2,
        sta_ativo VARCHAR2,
        dat_cadastro DATE,
        dat_cancelamento DATE
    );

    FUNCTION contar_produtos RETURN NUMBER;

END pkg_produto;


CREATE OR REPLACE PACKAGE BODY pkg_produto AS

    PROCEDURE adicionar_produto (
        cod_produto      NUMBER,
        nom_produto      VARCHAR2,
        cod_barra        VARCHAR2,
        sta_ativo        VARCHAR2,
        dat_cadastro     DATE,
        dat_cancelamento DATE
    ) IS
    BEGIN
        INSERT INTO produto VALUES ( cod_produto,
                                     nom_produto,
                                     cod_barra,
                                     sta_ativo,
                                     dat_cadastro,
                                     dat_cancelamento );

        COMMIT;
    END adicionar_produto;

    FUNCTION contar_produtos RETURN NUMBER IS
        total_produtos NUMBER;
    BEGIN
        SELECT
            COUNT(1)
        INTO total_produtos
        FROM
            produto;

        RETURN total_produtos;
    END contar_produtos;

END pkg_produto;

CALL pkg_produto.adicionar_produto(157, 'A braba', '777666', 'Ativo', '14-AUG-25', '');
SELECT pkg_produto.contar_produtos from dual;