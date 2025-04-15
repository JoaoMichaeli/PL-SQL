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
        raise_application_error(-ora20001, 'N�o encontrou');
        RETURN p_cod_pedido;
END;


/*
Fun��o 1 � fnc_percentual_desconto
Crie uma fun��o chamada `fnc_percentual_desconto` que, ao receber o c�digo de um pedido, calcule o percentual de desconto aplicado
sobre o valor total do pedido. A fun��o deve utilizar `JOIN` com a tabela `item_pedido` para validar que o pedido possui ao menos um item,
e deve tratar poss�veis exce��es como: pedido inexistente, divis�o por zero e erro gen�rico.
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
Fun��o 2 � fnc_media_itens_por_pedido
Crie uma fun��o que retorne a m�dia de itens por pedido considerando todos os pedidos com itens registrados.
Utilize `JOIN` com a tabela `historico_pedido` para garantir que os pedidos s�o v�lidos.
Implemente tratamento de erro para divis�o por zero e erro gen�rico.
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
            dbms_output.put_line('C�digo do pedido: ' || i.cod_pedido);
            dbms_output.put_line('M�dia de itens por pedido: ' || media_itens_pedido);
    EXCEPTION
        WHEN erro THEN
            raise_application_error(-20001, 'A divis�o n�o pode ser por 0');
END fnc_media_itens_por_pedido;
    


/*
Procedimento 1 � prc_relatorio_estoque_produto
Implemente um procedimento que receba o c�digo de um produto e exiba, via `DBMS_OUTPUT`, o total de unidades
movimentadas e a data da �ltima movimenta��o. Utilize um `LEFT JOIN` com a tabela `produto_composto`
para mostrar que o produto pode fazer parte de composi��es, mesmo que n�o tenha. Inclua tratamento para
aus�ncia de dados e erro gen�rico.
*/


/*
Procedimento 2 � prc_relatorio_composicao_ativa
Crie um procedimento que, dado o c�digo de um produto, exiba os componentes ativos que fazem parte de sua composi��o.
Use JOIN com a tabela `movimento_estoque` para relacionar os componentes com movimenta��es.
Implemente o procedimento utilizando um `FOR LOOP` com `CURSOR IMPL�CITO`, e trate erros gen�ricos.
*/




/*
Procedimento 3 � prc_relatorio_pedido
Desenvolva um procedimento que exiba informa��es detalhadas de um pedido, como:
valor total, desconto e status de entrega (`ENTREGUE` ou `PENDENTE`).
O procedimento deve aceitar o c�digo do pedido como par�metro e utilizar
JOIN com a tabela `item_pedido` para garantir que o pedido possua itens.
Inclua tratamento para pedido inexistente e erros gen�ricos.
*/