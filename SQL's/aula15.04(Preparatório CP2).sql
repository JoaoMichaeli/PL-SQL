SET SERVEROUTPUT ON;


/*
Fun��o 1 � fnc_percentual_desconto
Crie uma fun��o chamada `fnc_percentual_desconto` que, ao receber o c�digo de um pedido, calcule o percentual de desconto aplicado
sobre o valor total do pedido. A fun��o deve utilizar `JOIN` com a tabela `item_pedido` para validar que o pedido possui ao menos um item,
e deve tratar poss�veis exce��es como: pedido inexistente, divis�o por zero e erro gen�rico.

- Uso correto de JOIN 
- Retorno numérico com duas casas decimais (opcional, mas desejável) 
- Tratamento com EXCEPTION 
*/

CREATE OR REPLACE FUNCTION fnc_percentual_desconto (
    v_cod pedido.cod_pedido%TYPE
) RETURN NUMBER IS
    v_percent NUMBER;
BEGIN
    SELECT
        ROUND(( SUM(pedido.val_desconto) * 100 ) / SUM(pedido.val_total_pedido),2)
    INTO v_percent
    FROM
             pedido
        JOIN item_pedido ON pedido.cod_pedido = item_pedido.cod_pedido
    WHERE
        pedido.cod_pedido = v_cod
    GROUP BY
        pedido.cod_pedido;

    RETURN v_percent;
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20001, 'Pedido inexistente ou sem itens.');
    WHEN zero_divide THEN
        raise_application_error(-20002, 'Erro: divisão por zero.');
    WHEN OTHERS THEN
        raise_application_error(-20003, 'Erro genérico: ' || sqlerrm);
END fnc_percentual_desconto;

SELECT fnc_percentual_desconto(130501) FROM DUAL;


/*
Fun��o 2 � fnc_media_itens_por_pedido
Crie uma fun��o que retorne a m�dia de itens por pedido considerando todos os pedidos com itens registrados.
Utilize `JOIN` com a tabela `historico_pedido` para garantir que os pedidos s�o v�lidos.
Implemente tratamento de erro para divis�o por zero e erro gen�rico.

- Uso correto de agregações (COUNT, DISTINCT) 
- Uso de JOIN 
- Tratamento de exceções 
*/

CREATE OR REPLACE FUNCTION fnc_media_itens_por_pedido RETURN NUMBER IS
    v_media NUMBER;
BEGIN
    SELECT
        AVG(num_itens)
    INTO v_media
    FROM
        (
            SELECT
                pedido.cod_pedido,
                COUNT(item_pedido.cod_item_pedido) AS num_itens
            FROM
                     pedido
                JOIN historico_pedido ON pedido.cod_pedido = historico_pedido.cod_pedido
                JOIN item_pedido ON pedido.cod_pedido = item_pedido.cod_pedido
            GROUP BY
                pedido.cod_pedido
        );

    RETURN v_media;
EXCEPTION
    WHEN zero_divide THEN
        raise_application_error(-20001, 'Erro: divisão por zero.');
    WHEN OTHERS THEN
        raise_application_error(-20002, 'Erro genérico: ' || sqlerrm);
END fnc_media_itens_por_pedido;

SELECT fnc_media_itens_por_pedido FROM DUAL;


/*
Procedimento 1 � prc_relatorio_estoque_produto
Implemente um procedimento que receba o c�digo de um produto e exiba, via `DBMS_OUTPUT`, o total de unidades
movimentadas e a data da �ltima movimenta��o. Utilize um `LEFT JOIN` com a tabela `produto_composto`
para mostrar que o produto pode fazer parte de composi��es, mesmo que n�o tenha. Inclua tratamento para
aus�ncia de dados e erro gen�rico.

- Utilização de agregações (SUM, MAX) 
- Uso de LEFT JOIN 
- Impressão no terminal com DBMS_OUTPUT 
*/

CREATE OR REPLACE PROCEDURE prc_relatorio_estoque_produto (
    v_cod_produto estoque_produto.cod_produto%TYPE
) IS
    v_total NUMBER;
    v_data  DATE;
BEGIN
    SELECT
        SUM(estoque_produto.qtd_produto),
        MAX(estoque_produto.dat_estoque)
    INTO
        v_total,
        v_data
    FROM
        estoque_produto
        LEFT JOIN produto_composto ON estoque_produto.cod_produto = produto_composto.cod_produto
    WHERE
        estoque_produto.cod_produto = v_cod_produto;

    IF v_total = 0 OR v_total IS NULL THEN
        dbms_output.put_line('Produto inexistente ou sem movimentação.');
    ELSE
        dbms_output.put_line('Total de unidades movimentadas: ' || v_total);
        dbms_output.put_line('Data da última movimentação: ' || TO_CHAR(v_data, 'DD/MM/YYYY HH24:MI:SS'));
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Erro genérico: ' || SQLERRM);
END prc_relatorio_estoque_produto;


CALL prc_relatorio_estoque_produto(1);


/*
Procedimento 2 � prc_relatorio_composicao_ativa
Crie um procedimento que, dado o c�digo de um produto, exiba os componentes ativos que fazem parte de sua composi��o.
Use JOIN com a tabela `movimento_estoque` para relacionar os componentes com movimenta��es.
Implemente o procedimento utilizando um `FOR LOOP` com `CURSOR IMPL�CITO`, e trate erros gen�ricos.

- Uso de JOIN 
- Laço FOR ... IN (SELECT ...) LOOP 
- Impressão formatada com DBMS_OUTPUT 
*/

CREATE OR REPLACE PROCEDURE prc_relatorio_composicao_ativa (
    v_cod_produto IN produto.cod_produto%TYPE
) IS
    v_encontrou BOOLEAN := FALSE;
BEGIN
    FOR i IN (
        SELECT
            pc.cod_produto_relacionado AS componente,
            me.cod_tipo_movimento_estoque AS movimento,
            me.dat_movimento_estoque AS data_movimentacao
        FROM
            produto_composto pc
            JOIN movimento_estoque me ON pc.cod_produto_relacionado = me.cod_produto
        WHERE
            pc.cod_produto = v_cod_produto
            AND pc.sta_ativo = 'S'
    ) LOOP
        v_encontrou := TRUE;
        dbms_output.put_line('Componente: ' || i.componente);
        dbms_output.put_line(' | Movimento: ' || i.movimento);
        dbms_output.put_line(' | Data da movimentação: ' ||
            TO_CHAR(i.data_movimentacao, 'DD/MM/YYYY HH24:MI:SS'));
    END LOOP;

    IF NOT v_encontrou THEN
        dbms_output.put_line('Nenhum componente ativo encontrado para este produto.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Erro genérico: ' || SQLERRM);
END;


CALL prc_relatorio_composicao_ativa(1);


/*
Procedimento 3 � prc_relatorio_pedido
Desenvolva um procedimento que exiba informa��es detalhadas de um pedido, como:
valor total, desconto e status de entrega (`ENTREGUE` ou `PENDENTE`).
O procedimento deve aceitar o c�digo do pedido como par�metro e utilizar
JOIN com a tabela `item_pedido` para garantir que o pedido possua itens.
Inclua tratamento para pedido inexistente e erros gen�ricos.

- Lógica condicional (IF/ELSE) para status 
- Uso de JOIN 
- Uso correto de DBMS_OUTPUT.PUT_LINE 
*/

CREATE OR REPLACE PROCEDURE prc_relatorio_pedido (
    v_cod_pedido IN pedido.cod_pedido%TYPE
) IS
    v_valor_total NUMBER;
    v_desconto    NUMBER;
    v_status      VARCHAR2(20);
BEGIN
    SELECT
        pedido.val_total_pedido,
        pedido.val_desconto,
        CASE
            WHEN pedido.status = 'S' THEN
                'ENTREGUE'
            ELSE
                'PENDENTE'
        END AS status_entrega
    INTO
        v_valor_total,
        v_desconto,
        v_status
    FROM
             pedido 
        JOIN item_pedido ON pedido.cod_pedido = item_pedido.cod_pedido
    WHERE
        pedido.cod_pedido = v_cod_pedido
    GROUP BY
        pedido.val_total_pedido,
        pedido.val_desconto,
        pedido.status;

    dbms_output.put_line('Valor Total: ' || to_char(v_valor_total, 'FM999990.00'));
    dbms_output.put_line('Desconto: ' || to_char(v_desconto, 'FM999990.00'));
    dbms_output.put_line('Status de Entrega: ' || v_status);
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Pedido inexistente ou sem itens.');
    WHEN OTHERS THEN
        dbms_output.put_line('Erro genérico: ' || sqlerrm);
END prc_relatorio_pedido;


CALL prc_relatorio_pedido(130501);