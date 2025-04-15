SET SERVEROUTPUT ON;

/*-- 1.
Escreva um procedimento em PL/SQL denominado "ListarPedidosCliente" que recebe 
o c�digo de um cliente como par�metro e lista todos os pedidos associados a esse cliente, 
incluindo detalhes como o n�mero do pedido, a data do pedido e o valor total.
*/
CREATE OR REPLACE PROCEDURE prd_listarpedidoscliente (
    v_cod_cliente pedido.cod_cliente%TYPE
) AS
BEGIN
    FOR reg IN (
        SELECT
            cod_pedido,
            dat_pedido,
            ( val_total_pedido - val_desconto ) AS valor_real
        FROM
            pedido
        WHERE
            cod_cliente = v_cod_cliente
    ) LOOP
        dbms_output.put_line('C�digo cliente: ' || v_cod_cliente);
        dbms_output.put_line('C�digo pedido: ' || reg.cod_pedido);
        dbms_output.put_line('Data pedido: ' || reg.dat_pedido);
        dbms_output.put_line('Valor do pedido: ' || reg.valor_real);
        dbms_output.put_line('------------------------------');
    END LOOP;

    COMMIT;
END;

EXEC prd_listarpedidoscliente(1);


/*-- 2.
Desenvolva um procedimento em PL/SQL chamado "ListarItensPedido" que aceita 
o c�digo de um pedido como entrada e lista todos os itens inclu�dos nesse pedido,
fornecendo informa��es como o c�digo do item, o nome do produto e a quantidade.
*/
CREATE OR REPLACE PROCEDURE prd_listaritenspedido (
    v_cod_pedido pedido.cod_pedido%TYPE
) AS
BEGIN
    FOR p IN (
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
    ) LOOP
        dbms_output.put_line('C�digo do item: ' || p.cod_item_pedido);
        dbms_output.put_line('Nome Produto: ' || p.nom_produto);
        dbms_output.put_line('Quantidade item: ' || p.qtd_item);
        dbms_output.put_line('-----------------------------------------');
    END LOOP;

    COMMIT;
END;

exec prd_listaritenspedido(131130);

/*-- 3.
Crie um procedimento em PL/SQL denominado "ListarMovimentosEstoqueProduto" que 
recebe o c�digo de um produto como argumento e lista todos os movimentos de 
estoque associados a esse produto, incluindo detalhes como a data do movimento 
e o tipo de movimento.
*/
CREATE OR REPLACE PROCEDURE prd_listarmovimentosestoqueproduto (
    v_cod_produto produto.cod_produto%TYPE
) AS
BEGIN
    FOR m IN (
        SELECT
            produto.nom_produto,
            me.dat_movimento_estoque,
            abs(me.qtd_movimentacao_estoque) AS qtd_mov,
            tm.des_tipo_movimento_estoque
        FROM
                 produto
            JOIN movimento_estoque      me ON produto.cod_produto = me.cod_produto
            JOIN tipo_movimento_estoque tm ON me.cod_tipo_movimento_estoque = tm.cod_tipo_movimento_estoque
        WHERE
            produto.cod_produto = 2
    ) LOOP
        dbms_output.put_line('C�digo produto: ' || v_cod_produto);
        dbms_output.put_line('Nome produto: ' || m.nom_produto);
        dbms_output.put_line('Data movimenta��o: ' || m.dat_movimento_estoque);
        dbms_output.put_line('Quantidade de movimenta��o: ' || m.qtd_mov);
        dbms_output.put_line('Tipo movimenta��o: ' || m.des_tipo_movimento_estoque);
        dbms_output.put_line('---------------------------------------------------');
    END LOOP;

    COMMIT;
END;

EXEC prd_listarmovimentosestoqueproduto(2);

/*-- 4.
Crie um procedimento chamado prc_insere_produto para todas as colunas da tabela 
de produtos, valide: Se o nome do produto tem mais de 3 caracteres e n�o cont�m 
n�meros (0 a 9)
*/
CREATE OR REPLACE PROCEDURE prd_insere_produto (
    v_cod_produto  produto.cod_produto%TYPE,
    v_nome_produto produto.nom_produto%TYPE,
    v_cod_barra    produto.cod_barra%TYPE,
    v_status       produto.sta_ativo%TYPE,
    v_data_cad     produto.dat_cadastro%TYPE
) AS
BEGIN
    IF length(v_nome_produto) <= 3 OR regexp_like(v_nome_produto, '[0-9]') THEN
        dbms_output.put_line('Produto n�o adicionado! Nome n�o est� em conformidade');
    ELSE
        INSERT INTO produto (
            cod_produto,
            nom_produto,
            cod_barra,
            sta_ativo,
            dat_cadastro
        ) VALUES (
            v_cod_produto,
            v_nome_produto,
            v_cod_barra,
            v_status,
            v_data_cad
        );

        dbms_output.put_line('Produto '
                             || v_nome_produto
                             || ' adicionado com c�digo: '
                             || v_cod_produto);
    END IF;

    COMMIT;
END;

EXEC prd_insere_produto(51 ,'PlayStation 5', 7891234567420, 'Ativo', SYSDATE);
-- EXEC prd_insere_produto(51 ,'PLS', 7891234567420, 'Ativo', SYSDATE);

/*-- 5.
Crie um procedimento chamado prc_insere_cliente para inserir novos clientes, 
valide: Se o nome do cliente tem mais de 3 caracteres 
e n�o cont�m n�meros (0 a 9)
*/
CREATE OR REPLACE PROCEDURE prd_insere_cliente (
    v_cod_cliente cliente.cod_cliente%TYPE,
    v_nom_cliente cliente.nom_cliente%TYPE,
    tip_pessoa    cliente.tip_pessoa%TYPE,
    num_cpf_cnpj  cliente.num_cpf_cnpj%TYPE,
    dat_cadastro  cliente.dat_cadastro%TYPE,
    sta_ativo     cliente.sta_ativo%TYPE
) AS
BEGIN
    IF length(v_nom_cliente) <= 3 OR regexp_like(v_nom_cliente, '[0-9]') THEN
        dbms_output.put_line(' Cliente '
                             || v_nom_cliente
                             || ' n�o adicionado!');
        dbms_output.put_line('Nome do cliente precisa ter mais de 3 letras e n�o pode ter d�gitos (0-9)');
        dbms_output.put_line('-------------------------------------------------------------------------');
    ELSE
        INSERT INTO cliente (
            cod_cliente,
            nom_cliente,
            tip_pessoa,
            num_cpf_cnpj,
            dat_cadastro,
            sta_ativo
        ) VALUES (
            v_cod_cliente,
            v_nom_cliente,
            tip_pessoa,
            num_cpf_cnpj,
            dat_cadastro,
            sta_ativo
        );

    END IF;

    COMMIT;
END;

EXEC prd_insere_cliente(148, 'Saes', 'F', '12345678902', sysdate, 'S');