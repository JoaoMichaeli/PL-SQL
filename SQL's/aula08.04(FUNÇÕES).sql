/*
    Função é obrigada a retornar algum valor
    Dentro da função é permitido utilizar DDL
*/ 

CREATE OR REPLACE FUNCTION calc_fgts (
    valor NUMBER
) RETURN NUMBER IS
BEGIN
    RETURN valor * 0.08;
END calc_fgts;

SELECT calc_fgts(1000) FROM DUAL; // Chamando a função

-------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE prx_fgts AS
    v_valor NUMBER;
BEGIN
    v_valor := calc_fgts(150000); // Chamando a função na procedures
    dbms_output.put_line('O valor do FGTS é: ' || v_valor);
END;

CALL prx_fgts();

-------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION calc_fgts_val (
    valor NUMBER
) RETURN NUMBER IS
    meu_erro EXCEPTION;
    v_valor NUMBER;
BEGIN
    v_valor := valor * 0.08;
    IF v_valor * 0.08 < 80 THEN
        RAISE meu_erro;
    END IF;
    RETURN v_valor;
EXCEPTION
    WHEN meu_erro THEN
        raise_application_error(-20001, 'FGTS NÃO PODE SER MENOR QUE 80 REAIS');
END calc_fgts_val;

SELECT calc_fgts_val(25000) FROM DUAL;

-------------------------------------------------------------------------

// Exercícios

/*
1 - Crie um procedimento chamado prc_insere_produto para todas as colunas da tabela de produtos, valide:
    Se o nome do produto tem mais de 3 caracteres e não contem números (0 a 9).
*/

CREATE OR REPLACE PROCEDURE prc_insere_produto (
    v_cod              produto.cod_produto%TYPE,
    v_nom              produto.nom_produto%TYPE,
    v_cod_barra        produto.cod_barra%TYPE,
    v_ativo            produto.sta_ativo%TYPE,
    v_dat_cadastro     produto.dat_cadastro%TYPE,
    v_dat_cancelamento produto.dat_cancelamento%TYPE
) AS
BEGIN
    IF
        LENGTH(v_nom) > 3
        AND NOT regexp_like(v_nom, '[0-9]')
    THEN
        INSERT INTO produto VALUES (
            v_cod,
            v_nom,
            v_cod_barra,
            v_ativo,
            v_dat_cadastro,
            v_dat_cancelamento
        );

        dbms_output.put_line('Produto: '
                             || v_nom
                             || ' cadastrado com sucesso');
    ELSE
        raise_application_error(-20001, 'O nome do produto deve ter mais de 3 caracteres e não pode conter números.');
    END IF;
END;


CALL prc_insere_produto(1533, 'Cigarro', 7891234567000, 'Ativo', '03-MAY-24', '');

/*
2 - Crie um procedimento chamado prc_insere_cliente para inserir novos cliente, valide:
    Se o nome do cliente tem mais de 3 caracteres e não contem números (0 a 9).
*/

CREATE OR REPLACE PROCEDURE prc_insere_cliente (
    v_cod              cliente.cod_cliente%TYPE,
    v_nom              cliente.nom_cliente%TYPE,
    v_des_razao        cliente.des_razao_social%TYPE,
    v_pessoa           cliente.tip_pessoa%TYPE,
    v_cpf_cnpj         cliente.num_cpf_cnpj%TYPE,
    v_dat_cadastro     cliente.dat_cadastro%TYPE,
    v_dat_cancelamento cliente.dat_cancelamento%TYPE,
    v_ativo            cliente.sta_ativo%TYPE
) AS
BEGIN
    IF
        length(v_nom) > 3
        AND NOT regexp_like(v_nom, '[0-9]')
    THEN
        INSERT INTO cliente VALUES (
            v_cod,
            v_nom,
            v_des_razao,
            v_pessoa,
            v_cpf_cnpj,
            v_dat_cadastro,
            v_dat_cancelamento,
            v_ativo
        );

        dbms_output.put_line('Cliente: '
                             || v_nom
                             || ' cadastrado com sucesso.');
    ELSE
        raise_application_error(-20001, 'O nome do cliente deve ter mais de 3 caracteres e não pode conter números.');
    END IF;
END;

CALL prc_insere_cliente(1533, 'Menor peça', '', 'M', 12345678900, '15-MAY-23', '', 'S');

/*
3 - Crie uma função chamada fun_valida_nome que valide se o nome tem mais do que 3 caracteres e não tenha números.
*/
  
CREATE OR REPLACE FUNCTION fun_valida_nome (
    nome VARCHAR2(100)
) RETURN NUMBER IS
    meu_erro EXCEPTION;
BEGIN
    IF
        length(nome) > 3
        AND NOT regexp_like(nome, '[0-9]')
    THEN
        RAISE meu_erro;
    END IF;
    RETURN nome;
EXCEPTION
    WHEN meu_erro THEN
        raise_application_error(-20001, 'O nome deve conter mais de 3 caracteres e não pode conter números');
END fun_valida_nome;

SELECT fun_valida_nome('ab') FROM DUAL;

/*
4 - Altere os procedimentos dos exercícios 1 e 2 para chamar a função do exercício 3
*/

/*
5 - Altere o procedimento do exercício 1 para que tenha um último parâmetro chamado p_retorno do tipo varchar2 que deverá retornar a informação 'produto cadastrado com sucesso'.
*/

/*
6 - Crie um bloco anônimo e chame o procedimento do exercicio 1
*/