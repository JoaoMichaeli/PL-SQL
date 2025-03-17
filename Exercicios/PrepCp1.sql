SET SERVEROUTPUT ON;

--Crie um bloco anônimo que calcula o total de movimentações de estoque para um determinado produto. 
DECLARE
    v_codigo_produto     NUMBER;
    v_total_movimentacao NUMBER := 0;
BEGIN
    v_codigo_produto := &cod_produto;
    SELECT
        SUM(qtd_movimentacao_estoque)
    INTO v_total_movimentacao
    FROM
        movimento_estoque
    WHERE
        cod_produto = v_codigo_produto;

    dbms_output.put_line('Total de movimentação para o produto '
                         || v_codigo_produto
                         || ': '
                         || v_total_movimentacao);
END;


--Utilizando FOR crie um bloco anônimo que calcula a média de valores totais de pedidos para um cliente específico. 
DECLARE
    v_cod_cliente        NUMBER;
    v_total_pedidos      NUMBER := 0;
    v_quantidade_pedidos NUMBER := 0;
    v_media_pedidos      INTEGER;
BEGIN
    v_cod_cliente := &cod_cliente;
    FOR pedido IN (
        SELECT
            val_total_pedido
        FROM
            pedido
        WHERE
            cod_cliente = v_cod_cliente
    ) LOOP
        v_total_pedidos := v_total_pedidos + pedido.val_total_pedido;
        v_quantidade_pedidos := v_quantidade_pedidos + 1;
    END LOOP;

    IF v_quantidade_pedidos > 0 THEN
        v_media_pedidos := v_total_pedidos / v_quantidade_pedidos;
        dbms_output.put_line('Média dos pedidos para o cliente '
                             || v_cod_cliente
                             || ': '
                             || v_media_pedidos);
    ELSE
        dbms_output.put_line('Não existem pedidos para o clinete ' || v_cod_cliente);
    END IF;

END;


--Crie um bloco anônimo que exiba os produtos compostos ativos 
DECLARE
    CURSOR prod_compostos IS
    SELECT
        cod_produto_relacionado,
        cod_produto
    FROM
        produto_composto
    WHERE
        sta_ativo = 'S';

BEGIN
    FOR produto IN prod_compostos LOOP
        dbms_output.put_line('Código do produto: '
                             || produto_composto.cod_produto
                             || ' Produto relacionado: '
                             || produto_composto.cod_produto_relacionado);
    END LOOP;
END;


--Crie um bloco anônimo para calcular o total de movimentações de estoque para um determinado produto usando INNER JOIN com a tabela de tipo_movimento_estoque.
DECLARE
    v_codigo_produto     NUMBER;
    v_total_movimentacao NUMBER := 0;
BEGIN
    v_codigo_produto := &cod_produto;
    SELECT
        SUM(m.qtd_movimentacao_estoque)
    INTO v_total_movimentacao
    FROM
             movimento_estoque m
        INNER JOIN tipo_movimento_estoque t ON m.cod_tipo_movimento_estoque = t.cod_tipo_movimento_estoque
    WHERE
        m.cod_produto = v_codigo_produto;

    dbms_output.put_line('Total de movimentação para o produto '
                         || v_codigo_produto
                         || ': '
                         || v_total_movimentacao);
END;


--Crie um bloco anônimo para exibir os produtos compostos e, se houver, suas informações de estoque, usando LEFT JOIN com a tabela estoque_produto. 
DECLARE
    CURSOR prod_composto IS
    SELECT
        p.cod_produto,
        p.cod_produto_relacionado,
        e.qtd_estoque
    FROM
        produto_composto p
        LEFT JOIN estoque_produto  e ON p.cod_produto = e.cod_produto
    WHERE
        p.sta_ativo = 'S';

BEGIN
    FOR produto IN prod_composto LOOP
        dbms_output.put_line('Código do produto: '
                             || produto.cod_produto
                             || ' | Produto relacionado: '
                             || produto.cod_produto_relacionado
                             || ' | Quantidade em estoque: '
                             || nvl(produto.qtd_estoque, 0));
    END LOOP;
END;


--Crie um bloco que exiba as informações de pedidos e, se houver, as informações dos clientes relacionados usando RIGHT JOIN com a tabela cliente. 
DECLARE
    CURSOR pedidos_clientes IS
    SELECT
        p.cod_pedido,
        p.val_total_pedido,
        c.cod_cliente,
        c.nom_cliente
    FROM
        pedido  p
        RIGHT JOIN cliente c ON p.cod_cliente = c.cod_cliente;

BEGIN
    FOR pedido IN pedidos_clientes LOOP
        dbms_output.put_line('Código do Pedido: '
                             || nvl(pedido.cod_pedido, 'Sem pedido')
                             || ' | Valor Total: '
                             || nvl(pedido.val_total_pedido, 0)
                             || ' | Cliente: '
                             || pedido.nom_cliente
                             || ' | Código do Cliente: '
                             || pedido.cod_cliente);
    END LOOP;
END;
 

--Crie um bloco que calcule a média de valores totais de pedidos para um cliente específico e exibe as informações do cliente usando INNER JOIN com a tabela cliente. 
DECLARE
    v_cod_cliente        NUMBER;
    v_total_pedidos      NUMBER := 0;
    v_quantidade_pedidos NUMBER := 0;
    v_media_pedidos      INTEGER;
    v_nom_cliente       VARCHAR2(100);
BEGIN
    v_cod_cliente := &cod_cliente;

    SELECT c.nom_cliente INTO v_nom_cliente
    FROM cliente c
    WHERE c.cod_cliente = v_cod_cliente;

    FOR pedido IN (
        SELECT p.val_total_pedido
        FROM pedido p
        INNER JOIN cliente c
        ON p.cod_cliente = c.cod_cliente
        WHERE p.cod_cliente = v_cod_cliente
    ) LOOP
        v_total_pedidos := v_total_pedidos + pedido.val_total_pedido;
        v_quantidade_pedidos := v_quantidade_pedidos + 1;
    END LOOP;

    IF v_quantidade_pedidos > 0 THEN
        v_media_pedidos := v_total_pedidos / v_quantidade_pedidos;
        dbms_output.put_line('Cliente: ' || v_nom_cliente || ' (Código: ' || v_cod_cliente || ')');
        dbms_output.put_line('Média dos pedidos: ' || v_media_pedidos);
    ELSE
        dbms_output.put_line('Não existem pedidos para o cliente ' || v_nom_cliente || ' (Código: ' || v_cod_cliente || ')');
    END IF;

END;