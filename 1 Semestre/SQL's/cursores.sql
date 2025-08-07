SET SERVEROUTPUT ON;
/*      CURSORES      */
/*
Variáveis de cursores

Nomedocursor%rowcount : devolve o numero da linha processada até o momento (formato completo ou resumido).

NomedoCursor%isopen : retorna true ou false para determinar se um cursor está aberto ou não (formato completo).

NomedoCursor%found : retorna true ou false para determinar se um registro foi encontrado ou não (formato completo).

NomedoCursor%notfound : retorna true ou false para determinar se um registro  NÃO foi encontrado (formato completo).
*/

--EXEMPLO
DECLARE
    v_codigo produto.cod_produto%TYPE := 1;
    CURSOR cur_emp IS
    SELECT
        nom_produto
    FROM
        produto
    WHERE
        cod_produto = v_codigo;

BEGIN
    FOR x IN cur_emp LOOP
        INSERT INTO historico VALUES (
            v_codigo,
            x.nom_produto,
            sysdate
        );

        COMMIT;
    END LOOP;
END;

SELECT * FROM historico;


/*
Fazer um bloco anônimo com cursor  que realize uma consulta na tabela de clientes e retorne o código  e o nome do cliente,
use dbms_output para mostrar as informações como o exemplo abaixo:
    Cliente: 1  Nome: Jose da Silva
    Cliente: 2  Nome: Maria  da Silva
*/

DECLARE
    CURSOR c_consulta_cliente IS
    SELECT
        cod_cliente,
        nom_cliente
    FROM
        cliente;

BEGIN
    FOR x IN c_consulta_cliente LOOP
        dbms_output.put_line('Cliente: '
                             || x.cod_cliente
                             || ' | Nome: '
                             || x.nom_cliente);
    END LOOP;
END;

/*
Faça um procedimento chamado PRC_VALIDA_TOTAL_PEDIDO que receba como parametro o código do pedido e que utilize dois cursores,
um para localizar o pedido e outro para acessar os itens deste pedido ,
fazendo a soma dos itens e ao final verificar se a soma dos itens (quantidade * preço unitário) – desconto é igual ao total do pedido.
Caso os valores coincidam retorne pelo parametro p_retorno a mensagem ‘pedido ok’,
caso contrario retorne ‘total dos itens não coincide com valor total do pedido’
*/

DECLARE
    CURSOR c


/*
Faça um procedimento chamado PRC_DELETA_PEDIDO que receba como parametro o numero do pedido e que antes de excluir o
pedido execute um cursor na tabela de itens de pedido e faça o delete de cada um deles usando a técnica de ROWID.
*/