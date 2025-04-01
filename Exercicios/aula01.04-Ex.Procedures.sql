SET SERVEROUTPUT ON;

/*
1. Escreva um procedimento em PL/SQL denominado "ListarPedidosCliente" que recebe o código de um cliente como parâmetro e lista
todos os pedidos associados a esse cliente, incluindo detalhes como o número do pedido, a data do pedido e o valor total.
*/
CREATE OR REPLACE PROCEDURE pdr_ListarPedidosCliente ( v_cod_cliente pedido.cod_cliente%TYPE
) AS BEGIN
    FOR registro IN (
        SELECT
            cod_pedido,
            dat_pedido,
            ( val_total_pedido - val_desconto ) AS valor_real
        FROM
            pedido
        WHERE
            cod_cliente = v_cod_cliente
    ) LOOP
        dbms_output.put_line('Codigo cliente: ' || v_cod_cliente);
        dbms_output.put_line('Codigo pedido: ' || registro.cod_pedido);
        dbms_output.put_line('Data pedido: ' || registro.dat_pedido);
        dbms_output.put_line('Valor total: ' || registro.valor_real);
        dbms_output.put_line('------------------------------------------');
    END LOOP;

    COMMIT;
END;

CALL pdr_ListarPedidosCliente(1);


/*
2. Desenvolva um procedimento em PL/SQL chamado "ListarItensPedido" que aceita o código de um pedido como entrada e lista todos os
itens incluídos nesse pedido, fornecendo informações como o código do item, o nome do produto e a quantidade.
*/
CREATE OR REPLACE PROCEDURE pdr_ListarItensPedido (
    v_cod_pedido pedido.cod_pedido%TYPE
) AS
BEGIN
    FOR registro IN(
    SELECT
        pedido.cod_pedido,
        item_pedido.cod_item_pedido,
        item_pedido.qtd_item,
        produto.nom_produto
    FROM
             pedido
        JOIN item_pedido ON ( pedido.cod_pedido = item_pedido.cod_pedido )
        JOIN produto ON ( item_pedido.cod_produto = produto.cod_produto )
    WHERE
        pedido.cod_pedido = v_cod_pedido
    )LOOP
        dbms_output.put_line('Código do pedido: ' || v_cod_pedido);
        dbms_output.put_line('Nome produto: ' || registro.nom_produto);
        dbms_output.put_line('Código do item: ' || registro.cod_item_pedido);
        dbms_output.put_line('Quantidade do item: ' || registro.qtd_item);
        dbms_output.put_line('-----------------------------------------');
    END LOOP;

    COMMIT;
END;

CALL pdr_listaritenspedido(131130);


/*
3.	Crie um procedimento em PL/SQL denominado "ListarMovimentosEstoqueProduto" que recebe o código de um produto como
argumento e lista todos os movimentos de estoque associados a esse produto, incluindo detalhes como a data do movimento e o tipo de movimento.
*/
CREATE OR REPLACE PROCEDURE pdr_listarmovimentosestoqueproduto (
    v_cod_produto produto.cod_produto%TYPE
) AS
BEGIN
    FOR registro IN (
        SELECT
            produto.nom_produto,
            produto.cod_produto,
            movimento_estoque.dat_movimento_estoque,
            tipo_movimento_estoque.des_tipo_movimento_estoque
        FROM
                 produto
            JOIN movimento_estoque ON ( produto.cod_produto = movimento_estoque.cod_produto )
            JOIN tipo_movimento_estoque ON ( tipo_movimento_estoque.cod_tipo_movimento_estoque = movimento_estoque.cod_tipo_movimento_estoque
            )
        WHERE
            produto.cod_produto = v_cod_produto
    ) LOOP
        dbms_output.put_line('Código produto: ' || v_cod_produto);
        dbms_output.put_line('Nome produto: ' || registro.nom_produto);
        dbms_output.put_line('Data movimentação: ' || registro.dat_movimento_estoque);
        dbms_output.put_line('Tipo movimentação: ' || registro.des_tipo_movimento_estoque);
        dbms_output.put_line('-----------------------------------------');
    END LOOP;

    COMMIT;
END;

CALL pdr_listarmovimentosestoqueproduto(2);


/*
4.	Crie um procedimento chamado prc_insere_produto para todas as colunas da tabela de produtos, valide:
Se o nome do produto tem mais de 3 caracteres e não contêm números (0 a 9)
*/
CREATE OR REPLACE PROCEDURE pdr_insereproduto AS
BEGIN
    FOR reg IN (
        SELECT
            nom_produto
        FROM
            produto
    ) LOOP
        IF
            length(reg.nom_produto) > 3
            AND NOT regexp_like(reg.nom_produto, '[0-9]')
        THEN
            dbms_output.put_line('Nome produto: ' || reg.nom_produto);
            dbms_output.put_line('----------------------------------------');
        END IF;
    END LOOP;

    COMMIT;
END;

CALL pdr_insereproduto();

/*
5.	Crie um procedimento chamado prc_insere_cliente para inserir novos clientes, valide:
Se o nome do cliente tem mais de 3 caracteres e não contêm números (0 a 9)
*/
CREATE OR REPLACE PROCEDURE pdr_insere_cliente AS
BEGIN
    FOR registro IN (
        INSERT
            
