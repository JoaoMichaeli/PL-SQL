SET 
/*      CURSORES      */
/*
Vari�veis de cursores

Nomedocursor%rowcount : devolve o numero da linha processada at� o momento (formato completo ou resumido).

NomedoCursor%isopen : retorna true ou false para determinar se um cursor est� aberto ou n�o (formato completo).

NomedoCursor%found : retorna true ou false para determinar se um registro foi encontrado ou n�o (formato completo).

NomedoCursor%notfound : retorna true ou false para determinar se um registro  N�O foi encontrado (formato completo).
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
Fazer um bloco an�nimo com cursor  que realize uma consulta na tabela de clientes e retorne o c�digo  e o nome do cliente,
use dbms_output para mostrar as informa��es como o exemplo abaixo:
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
                             || 'Nome: '
                             || x.nom_cliente);
    END LOOP;
END;

