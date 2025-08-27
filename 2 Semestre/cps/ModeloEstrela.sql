-- =====================================================
-- MODELO ESTRELA: Sistema de Pedidos
-- =====================================================

-- =====================
-- TABELA FATO
-- =====================
CREATE TABLE fato_pedido (
    sk_tempo        NUMBER(10) NOT NULL,
    sk_cliente      NUMBER(10) NOT NULL,
    sk_produto      NUMBER(10) NOT NULL,
    sk_vendedor     NUMBER(10) NOT NULL,
    sk_localidade   NUMBER(10) NOT NULL,
    cod_pedido      NUMBER(10) NOT NULL,
    cod_item_pedido NUMBER(10) NOT NULL,
    qtd_itens       NUMBER(10),
    val_unitario    NUMBER(12,2),
    val_desconto_item   NUMBER(12,2),
    val_total_item      NUMBER(12,2),
    val_desconto_pedido NUMBER(12,2),
    val_total_pedido    NUMBER(12,2),
    status_pedido   VARCHAR2(50)
);

-- =====================
-- DIMENSÕES
-- =====================
CREATE TABLE dim_tempo (
    sk_tempo NUMBER(10) PRIMARY KEY,
    data_completa DATE,
    dia NUMBER(2),
    mes NUMBER(2),
    ano NUMBER(4),
    trimestre NUMBER(1),
    semestre NUMBER(1),
    nome_mes VARCHAR2(20),
    nome_dia_semana VARCHAR2(20),
    flag_fim_semana CHAR(1),
    flag_feriado CHAR(1)
);

CREATE TABLE dim_cliente (
    sk_cliente NUMBER(10) PRIMARY KEY,
    cod_cliente NUMBER(10),
    nome_cliente VARCHAR2(100),
    email VARCHAR2(100),
    status_cliente VARCHAR2(20),
    data_cadastro DATE,
    data_inicio_validade DATE,
    data_fim_validade DATE,
    versao NUMBER(5)
);
CREATE SEQUENCE seq_dim_cliente START WITH 1 INCREMENT BY 1;

CREATE TABLE dim_produto (
    sk_produto NUMBER(10) PRIMARY KEY,
    cod_produto NUMBER(10),
    nome_produto VARCHAR2(100),
    cod_barras VARCHAR2(20),
    status_produto VARCHAR2(20),
    data_cadastro DATE,
    data_inicio_validade DATE,
    data_fim_validade DATE,
    versao NUMBER(5)
);
CREATE SEQUENCE seq_dim_produto START WITH 1 INCREMENT BY 1;

CREATE TABLE dim_vendedor (
    sk_vendedor NUMBER(10) PRIMARY KEY,
    cod_vendedor NUMBER(4),
    nome_vendedor VARCHAR2(100),
    status_vendedor VARCHAR2(20),
    data_inicio_validade DATE,
    data_fim_validade DATE,
    versao NUMBER(5)
);
CREATE SEQUENCE seq_dim_vendedor START WITH 1 INCREMENT BY 1;

CREATE TABLE dim_localidade (
    sk_localidade NUMBER(10) PRIMARY KEY,
    cod_cidade NUMBER(6),
    nome_cidade VARCHAR2(100),
    cod_estado NUMBER(2),
    nome_estado VARCHAR2(50),
    cod_regiao NUMBER(1),
    nome_regiao VARCHAR2(50),
    data_inicio_validade DATE,
    data_fim_validade DATE,
    versao NUMBER(5)
);
CREATE SEQUENCE seq_dim_localidade START WITH 1 INCREMENT BY 1;

-- =====================================================
-- PACKAGE ETL: CARGA DE DIMENSÕES E FATO
-- =====================================================
CREATE OR REPLACE PACKAGE pkg_etl_pedidos AS
    PROCEDURE prc_carga_dim_tempo;
    PROCEDURE prc_carga_dim_cliente;
    PROCEDURE prc_carga_dim_produto;
    PROCEDURE prc_carga_dim_vendedor;
    PROCEDURE prc_carga_dim_localidade;
    PROCEDURE prc_carga_fato_pedido;
    PROCEDURE prc_validar_dimensoes;
    PROCEDURE prc_validar_fato;
    PROCEDURE prc_executar_etl_completo;
END pkg_etl_pedidos;
/

CREATE OR REPLACE PACKAGE BODY pkg_etl_pedidos AS

    -- DIM CLIENTE
    PROCEDURE prc_carga_dim_cliente IS
        v_validos NUMBER;
        v_invalidos NUMBER;
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE dim_cliente';

        INSERT INTO dim_cliente (sk_cliente, cod_cliente, nome_cliente, email, status_cliente, versao, data_inicio_validade)
        SELECT seq_dim_cliente.NEXTVAL, cod_cliente, nome, email, sta_ativo, 1, SYSDATE
        FROM cliente
        WHERE cod_cliente IS NOT NULL AND nome IS NOT NULL;

        v_validos := SQL%ROWCOUNT;
        SELECT COUNT(*) INTO v_invalidos FROM cliente WHERE cod_cliente IS NULL OR nome IS NULL;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Cliente: ' || v_validos || ' válidos / ' || v_invalidos || ' inválidos');
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro Cliente: ' || SQLERRM);
    END prc_carga_dim_cliente;

    -- DIM PRODUTO
    PROCEDURE prc_carga_dim_produto IS
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE dim_produto';

        INSERT INTO dim_produto (sk_produto, cod_produto, nome_produto, cod_barras, status_produto, versao, data_inicio_validade)
        SELECT seq_dim_produto.NEXTVAL, cod_produto, nom_produto, cod_barra, sta_ativo, 1, SYSDATE
        FROM produto
        WHERE cod_produto IS NOT NULL AND nom_produto IS NOT NULL;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Produto: ' || SQL%ROWCOUNT || ' registros válidos');
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro Produto: ' || SQLERRM);
    END prc_carga_dim_produto;

    -- DIM VENDEDOR
    PROCEDURE prc_carga_dim_vendedor IS
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE dim_vendedor';

        INSERT INTO dim_vendedor (sk_vendedor, cod_vendedor, nome_vendedor, status_vendedor, versao, data_inicio_validade)
        SELECT seq_dim_vendedor.NEXTVAL, cod_vendedor, nom_vendedor, sta_ativo, 1, SYSDATE
        FROM vendedor
        WHERE cod_vendedor IS NOT NULL AND nom_vendedor IS NOT NULL;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Vendedor: ' || SQL%ROWCOUNT || ' registros válidos');
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro Vendedor: ' || SQLERRM);
    END prc_carga_dim_vendedor;

    -- DIM TEMPO
    PROCEDURE prc_carga_dim_tempo IS
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE dim_tempo';

        INSERT INTO dim_tempo (sk_tempo, data_completa, dia, mes, ano, trimestre, semestre, nome_mes, nome_dia_semana, flag_fim_semana, flag_feriado)
        SELECT DISTINCT 
               TO_NUMBER(TO_CHAR(dat_pedido, 'YYYYMMDD')),
               TRUNC(dat_pedido),
               EXTRACT(DAY FROM dat_pedido),
               EXTRACT(MONTH FROM dat_pedido),
               EXTRACT(YEAR FROM dat_pedido),
               TO_NUMBER(TO_CHAR(dat_pedido,'Q')),
               CASE WHEN EXTRACT(MONTH FROM dat_pedido) <= 6 THEN 1 ELSE 2 END,
               TO_CHAR(dat_pedido,'MONTH'),
               TO_CHAR(dat_pedido,'DAY'),
               CASE WHEN TO_CHAR(dat_pedido,'DY') IN ('SAT','SUN') THEN 'S' ELSE 'N' END,
               'N'
        FROM pedido
        WHERE dat_pedido IS NOT NULL;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Tempo: ' || SQL%ROWCOUNT || ' registros');
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro Tempo: ' || SQLERRM);
    END prc_carga_dim_tempo;

    -- DIM LOCALIDADE
    PROCEDURE prc_carga_dim_localidade IS
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE dim_localidade';

        INSERT INTO dim_localidade (sk_localidade, cod_cidade, nome_cidade, cod_estado, nome_estado, cod_regiao, nome_regiao, versao, data_inicio_validade)
        SELECT seq_dim_localidade.NEXTVAL, c.cod_cidade, c.nom_cidade, e.cod_estado, e.nom_estado, r.cod_regiao, r.nom_regiao, 1, SYSDATE
        FROM cidade c
        JOIN estado e ON c.cod_estado = e.cod_estado
        JOIN regiao r ON e.cod_regiao = r.cod_regiao;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Localidade: ' || SQL%ROWCOUNT || ' registros');
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro Localidade: ' || SQLERRM);
    END prc_carga_dim_localidade;

    -- FATO PEDIDO
    PROCEDURE prc_carga_fato_pedido IS
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE fato_pedido';

        INSERT INTO fato_pedido (
            sk_tempo, sk_cliente, sk_produto, sk_vendedor, sk_localidade,
            cod_pedido, cod_item_pedido, qtd_itens, val_unitario,
            val_desconto_item, val_total_item, val_desconto_pedido,
            val_total_pedido, status_pedido
        )
        SELECT dt.sk_tempo, dc.sk_cliente, dp.sk_produto, dv.sk_vendedor, dl.sk_localidade,
               p.cod_pedido, ip.cod_item_pedido, ip.qtd_item, ip.val_unitario_item,
               ip.val_desconto_item, (ip.qtd_item * ip.val_unitario_item - NVL(ip.val_desconto_item,0)),
               p.val_desconto, p.val_total_pedido, p.status
        FROM pedido p
        JOIN item_pedido ip ON p.cod_pedido = ip.cod_pedido
        JOIN dim_tempo dt ON TRUNC(p.dat_pedido) = dt.data_completa
        JOIN dim_cliente dc ON p.cod_cliente = dc.cod_cliente
        JOIN dim_produto dp ON ip.cod_produto = dp.cod_produto
        JOIN dim_vendedor dv ON p.cod_vendedor = dv.cod_vendedor
        JOIN endereco_cliente ec ON p.seq_endereco_cliente = ec.seq_endereco_cliente
        JOIN dim_localidade dl ON ec.cod_cidade = dl.cod_cidade;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Fato Pedido: ' || SQL%ROWCOUNT || ' registros');
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro Fato: ' || SQLERRM);
    END prc_carga_fato_pedido;

    -- VALIDACAO DIMENSOES
    PROCEDURE prc_validar_dimensoes IS
        v_total NUMBER;
    BEGIN
        FOR t IN (SELECT 'dim_cliente' tabela FROM dual UNION ALL
                  SELECT 'dim_produto' FROM dual UNION ALL
                  SELECT 'dim_vendedor' FROM dual UNION ALL
                  SELECT 'dim_tempo' FROM dual UNION ALL
                  SELECT 'dim_localidade' FROM dual) LOOP
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM '||t.tabela INTO v_total;
            DBMS_OUTPUT.PUT_LINE(t.tabela || ': ' || v_total || ' registros');
        END LOOP;
    END prc_validar_dimensoes;

    -- VALIDACAO FATO
    PROCEDURE prc_validar_fato IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total FROM fato_pedido;
        DBMS_OUTPUT.PUT_LINE('Fato Pedido: ' || v_total || ' registros');
    END prc_validar_fato;

    -- EXECUCAO COMPLETA
    PROCEDURE prc_executar_etl_completo IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('>>> INICIANDO ETL COMPLETO <<<');
        prc_carga_dim_tempo;
        prc_carga_dim_cliente;
        prc_carga_dim_produto;
        prc_carga_dim_vendedor;
        prc_carga_dim_localidade;
        prc_validar_dimensoes;
        prc_carga_fato_pedido;
        prc_validar_fato;
        DBMS_OUTPUT.PUT_LINE('>>> ETL FINALIZADO <<<');
    END prc_executar_etl_completo;

END pkg_etl_pedidos;
/

-- =====================================================
-- AUDITORIA DIMENSÕES
-- =====================================================
CREATE TABLE auditoria_dimensoes (
    id_auditoria NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tabela       VARCHAR2(50),
    operacao     VARCHAR2(10),
    usuario      VARCHAR2(50),
    data_hora    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_antigo VARCHAR2(4000),
    valor_novo   VARCHAR2(4000)
);

-- =======================
-- TRIGGERS DE AUDITORIA
-- =======================
-- Cliente
CREATE OR REPLACE TRIGGER trg_audit_cliente
AFTER INSERT OR UPDATE OR DELETE ON dim_cliente
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_valor_antigo VARCHAR2(4000);
    v_valor_novo   VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_valor_novo := 'ID=' || :NEW.sk_cliente || ', Nome=' || :NEW.nome_cliente;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_valor_antigo := 'ID=' || :OLD.sk_cliente || ', Nome=' || :OLD.nome_cliente;
        v_valor_novo   := 'ID=' || :NEW.sk_cliente || ', Nome=' || :NEW.nome_cliente;
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
        v_valor_antigo := 'ID=' || :OLD.sk_cliente || ', Nome=' || :OLD.nome_cliente;
    END IF;

    INSERT INTO auditoria_dimensoes (tabela, operacao, usuario, valor_antigo, valor_novo)
    VALUES ('DIM_CLIENTE', v_operacao, USER, v_valor_antigo, v_valor_novo);
END;
/

-- Produto
CREATE OR REPLACE TRIGGER trg_audit_produto
AFTER INSERT OR UPDATE OR DELETE ON dim_produto
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_valor_antigo VARCHAR2(4000);
    v_valor_novo   VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_valor_novo := 'ID=' || :NEW.sk_produto || ', Nome=' || :NEW.nome_produto;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_valor_antigo := 'ID=' || :OLD.sk_produto || ', Nome=' || :OLD.nome_produto;
        v_valor_novo   := 'ID=' || :NEW.sk_produto || ', Nome=' || :NEW.nome_produto;
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
        v_valor_antigo := 'ID=' || :OLD.sk_produto || ', Nome=' || :OLD.nome_produto;
    END IF;

    INSERT INTO auditoria_dimensoes (tabela, operacao, usuario, valor_antigo, valor_novo)
    VALUES ('DIM_PRODUTO', v_operacao, USER, v_valor_antigo, v_valor_novo);
END;
/

-- Vendedor
CREATE OR REPLACE TRIGGER trg_audit_vendedor
AFTER INSERT OR UPDATE OR DELETE ON dim_vendedor
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_valor_antigo VARCHAR2(4000);
    v_valor_novo   VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_valor_novo := 'ID=' || :NEW.sk_vendedor || ', Nome=' || :NEW.nome_vendedor;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_valor_antigo := 'ID=' || :OLD.sk_vendedor || ', Nome=' || :OLD.nome_vendedor;
        v_valor_novo   := 'ID=' || :NEW.sk_vendedor || ', Nome=' || :NEW.nome_vendedor;
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
        v_valor_antigo := 'ID=' || :OLD.sk_vendedor || ', Nome=' || :OLD.nome_vendedor;
    END IF;

    INSERT INTO auditoria_dimensoes (tabela, operacao, usuario, valor_antigo, valor_novo)
    VALUES ('DIM_VENDEDOR', v_operacao, USER, v_valor_antigo, v_valor_novo);
END;
/

-- Tempo
CREATE OR REPLACE TRIGGER trg_audit_tempo
AFTER INSERT OR UPDATE OR DELETE ON dim_tempo
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_valor_antigo VARCHAR2(4000);
    v_valor_novo   VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_valor_novo := 'ID=' || :NEW.sk_tempo || ', Data=' || TO_CHAR(:NEW.data_completa, 'DD/MM/YYYY');
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_valor_antigo := 'ID=' || :OLD.sk_tempo || ', Data=' || TO_CHAR(:OLD.data_completa, 'DD/MM/YYYY');
        v_valor_novo   := 'ID=' || :NEW.sk_tempo || ', Data=' || TO_CHAR(:NEW.data_completa, 'DD/MM/YYYY');
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
        v_valor_antigo := 'ID=' || :OLD.sk_tempo || ', Data=' || TO_CHAR(:OLD.data_completa, 'DD/MM/YYYY');
    END IF;

    INSERT INTO auditoria_dimensoes (tabela, operacao, usuario, valor_antigo, valor_novo)
    VALUES ('DIM_TEMPO', v_operacao, USER, v_valor_antigo, v_valor_novo);
END;
/

-- Localidade
CREATE OR REPLACE TRIGGER trg_audit_localidade
AFTER INSERT OR UPDATE OR DELETE ON dim_localidade
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_valor_antigo VARCHAR2(4000);
    v_valor_novo   VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_valor_novo := 'ID=' || :NEW.sk_localidade || ', Cidade=' || :NEW.nome_cidade;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_valor_antigo := 'ID=' || :OLD.sk_localidade || ', Cidade=' || :OLD.nome_cidade;
        v_valor_novo   := 'ID=' || :NEW.sk_localidade || ', Cidade=' || :NEW.nome_cidade;
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
        v_valor_antigo := 'ID=' || :OLD.sk_localidade || ', Cidade=' || :OLD.nome_cidade;
    END IF;

    INSERT INTO auditoria_dimensoes (tabela, operacao, usuario, valor_antigo, valor_novo)
    VALUES ('DIM_LOCALIDADE', v_operacao, USER, v_valor_antigo, v_valor_novo);
END;
/
