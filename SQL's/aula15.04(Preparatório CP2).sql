CREATE OR REPLACE FUNCTION cal_desc (
    p_cod_pedido NUMBER
) RETURN NUMBER IS
    val_desc NUMBER;
BEGIN
    SELECT
        ( SUM(val_desconto_item) ) / 100
    INTO val_desc
    FROM
             pedido a
        INNER JOIN item_pedido b ON ( a.cod_pedido = b.cod_pedido )
    WHERE
        a.cod_pedido = p_cod_pedido;

EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-ora20001, 'Não encontrou');
        RETURN p_cod_pedido;
END;


/*
Função 1 – fnc_percentual_desconto
Crie uma função chamada `fnc_percentual_desconto` que, ao receber o código de um pedido, calcule o percentual de desconto aplicado
sobre o valor total do pedido. A função deve utilizar `JOIN` com a tabela `item_pedido` para validar que o pedido possui ao menos um item,
e deve tratar possíveis exceções como: pedido inexistente, divisão por zero e erro genérico.
*/

CREATE OR REPLACE FUNCTION fnc_percentual_desconto (
    v_cod pedido.cod_pedido%TYPE
) RETURN NUMBER IS
    erro EXCEPTION;
BEGIN
    SELECT
        ( SUM(val_desconto_item.item_pedido) ) / 100
    FROM
             pedido
        JOIN item_pedido ON ( pedido.cod_pedido = item_pedido.cod_pedido )
    WHERE
        pedido.cod_pedido = item_pedido.cod_pedido;

EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20001, '');
    
    RETURN v_cod;
END;

/*
Função 2 – fnc_media_itens_por_pedido
Crie uma função que retorne a média de itens por pedido considerando todos os pedidos com itens registrados.
Utilize `JOIN` com a tabela `historico_pedido` para garantir que os pedidos são válidos.
Implemente tratamento de erro para divisão por zero e erro genérico.
*/

CREATE OR REPLACE FUNCTION fnc_media_itens_por_pedido (
    v_cod pedido.cod_pedido%TYPE
) RETURN NUMBER IS 
    erro EXCEPTION;
    v_cod pedido.cod_pedido%TYPE;
BEGIN 
    IF 
        val_total_pedido !=  0
    THEN
        FOR i IN(
            SELECT 
                pedido.cod_pedido,
                item_pedido.cod_item_pedido,
                item_pedido.qtd_item,
                historico_pedido.cod_cliente
            FROM
                pedido
                JOIN item_pedido ON ( pedido.cod_pedido = item_pedido.cod_pedido)
                JOIN historico_pedido ON (item_pedido.cod_pedido = historico_pedido.cod_pedido)
            WHERE
                pedido.cod_pedido = v_cod_pedido
        ) LOOP
            dbms_output.put_line('Código do pedido: ' || i.cod_pedido);
            dbms_output.put_line('Média de itens por pedido: ' || media_itens_pedido);
    EXCEPTION
        WHEN erro THEN
            raise_application_error(-20001, 'A divisão não pode ser por 0');
END fnc_media_itens_por_pedido;
    


/*
Procedimento 1 – prc_relatorio_estoque_produto
Implemente um procedimento que receba o código de um produto e exiba, via `DBMS_OUTPUT`, o total de unidades
movimentadas e a data da última movimentação. Utilize um `LEFT JOIN` com a tabela `produto_composto`
para mostrar que o produto pode fazer parte de composições, mesmo que não tenha. Inclua tratamento para
ausência de dados e erro genérico.
*/


/*
Procedimento 2 – prc_relatorio_composicao_ativa
Crie um procedimento que, dado o código de um produto, exiba os componentes ativos que fazem parte de sua composição.
Use JOIN com a tabela `movimento_estoque` para relacionar os componentes com movimentações.
Implemente o procedimento utilizando um `FOR LOOP` com `CURSOR IMPLÍCITO`, e trate erros genéricos.
*/




/*
Procedimento 3 – prc_relatorio_pedido
Desenvolva um procedimento que exiba informações detalhadas de um pedido, como:
valor total, desconto e status de entrega (`ENTREGUE` ou `PENDENTE`).
O procedimento deve aceitar o código do pedido como parâmetro e utilizar
JOIN com a tabela `item_pedido` para garantir que o pedido possua itens.
Inclua tratamento para pedido inexistente e erros genéricos.
*/