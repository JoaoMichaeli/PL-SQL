SET SERVEROUTPUT ON;

INSERT INTO pais VALUES (
    24,
    'Egito'
);

COMMIT;

SELECT
    *
FROM
    pais;

DECLARE
    cod_pais NUMBER;
    nom_pais VARCHAR2(50);
BEGIN
    cod_pais := &cod_pais;
    nom_pais := '&nom_pais';
    INSERT INTO pais VALUES (
        cod_pais,
        nom_pais
    );

END;

-- PROCEDURES INSERT
CREATE OR REPLACE PROCEDURE prd_insert_pais (
    p_cod  pais.cod_pais%TYPE,
    p_nome pais.nom_pais%TYPE
) AS
BEGIN
    INSERT INTO pais VALUES (
        p_cod,
        p_nome
    );

    COMMIT;
END;

-- MÉTODOS DA LINGUAGEM DE CHAMAD
CALL prd_insert_pais(); --JAVA, PYTHON
EXEC prd_insert_pais(); -- JAVA
EXECUTE prd_insert_pais(); --PYTHON, .NET

-- JAVA, .NET
BEGIN
    prd_insert_pais();
END;

-- CHAMANDO O MÉTODO
CALL prd_insert_pais(555, 'JAMAICA');


-- PROCEDURES DELETE
CREATE OR REPLACE PROCEDURE prd_delete_pais (
    p_cod pais.cod_pais%TYPE
) AS
BEGIN
    DELETE FROM pais
    WHERE
        pais.cod_pais = p_cod;

    COMMIT;
END;

CALL prd_delete_pais(555);

-- PROCEDURES UPDATE
CREATE OR REPLACE PROCEDURE prd_update_pais (
    p_cod  pais.cod_pais%TYPE,
    p_nome pais.nom_pais%TYPE
) AS
BEGIN
    UPDATE pais
    SET
        pais.nom_pais = p_nome
    WHERE
        pais.cod_pais = p_cod;

    COMMIT;
END;

CALL prd_update_pais(50, 'Velha zelandia');

/*
    Crie uma procedure que você informe o código do cliente e ela retorna as seguintes informações:
    
    Nome do cliente
    Cod do produto
    Cod do pedido
    Nome do produto
    Total por pedidos
*/

SELECT
    *
FROM
         pedido a
    INNER JOIN cliente     b ON ( a.cod_cliente = b.cod_cliente )
    JOIN item_pedido c ON ( a.cod_pedido = c.cod_pedido )
    JOIN produto     d ON ( c.cod_produto = d.cod_produto );


CREATE OR REPLACE PROCEDURE prd_relatorio_cliente (
    v_cod_cliente cliente.cod_cliente%TYPE,
    v_cod_pedido pedido.cod_pedido%TYPE
) AS
BEGIN
    FOR registro IN (
        SELECT
            b.nom_cliente,
            a.cod_pedido,
            c.cod_produto,
            d.nom_produto,
            SUM(a.val_total_pedido) "Total Pedido"
        FROM
                 pedido a
            INNER JOIN cliente     b ON ( a.cod_cliente = b.cod_cliente )
            JOIN item_pedido c ON ( a.cod_pedido = c.cod_pedido )
            JOIN produto     d ON ( c.cod_produto = d.cod_produto )
        WHERE
            b.cod_cliente = v_cod_cliente AND c.cod_pedido = v_cod_pedido
        GROUP BY
            b.nom_cliente,
            a.cod_pedido,
            c.cod_produto,
            d.nom_produto
    ) LOOP
        dbms_output.put_line('Nome : ' || registro.nom_cliente);
        dbms_output.put_line('Código pedido: ' || registro.cod_pedido);
        dbms_output.put_line('Nome produto: ' || registro.nom_produto);
        dbms_output.put_line('Valor total pedido: ' || registro."Total Pedido");
    END LOOP;

    COMMIT;
END;

select * from cliente;
select * from pedido;

call prd_relatorio_cliente(1,130501);