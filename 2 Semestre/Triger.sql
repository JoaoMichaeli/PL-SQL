CREATE TABLE pedido_novos AS SELECT * FROM pedido;

ALTER TABLE pedido_novos ADD status VARCHAR2(30);

SELECT * FROM pedido_novos;

-------- TRIGGER --------

CREATE OR REPLACE TRIGGER trg_pedido BEFORE
    INSERT ON pedido_novos
    FOR EACH ROW
BEGIN
 -- Atualiza o status do pedido para "Novo" após a inserção
    IF :new.status IS NULL THEN
        :new.status := 'Novo Pedido';
    END IF;
END;

-------- FAZENDO UM INSERT COM VALOR NULO E PREENCHIDO --------

INSERT INTO pedido_novos (
    cod_pedido,
    cod_cliente,
    status
) VALUES ( 111111,
           74,
           null );
           
INSERT INTO pedido_novos (
    cod_pedido,
    cod_cliente,
    status
) VALUES ( 111111,
           74,
           1 );
        
SELECT * FROM pedido_novos where cod_pedido = 111111;


-------- AUDITORIA --------

CREATE TABLE tb_auditoria (
    id       NUMBER GENERATED ALWAYS AS IDENTITY,
    tabela   VARCHAR2(30),
    operacao VARCHAR2(30),
    data     DATE,
    usuario  VARCHAR2(30)
);


-------- Criação de uma trigger de auditoria para mudança na table de pedidos novos --------

CREATE OR REPLACE TRIGGER trg_auditoria
    AFTER INSERT OR UPDATE OR DELETE ON pedido_novos
    FOR EACH ROW
DECLARE
    operacao VARCHAR2(30);
    nome_usuario VARCHAR2(100);
BEGIN
    -- Determina a operação realizada ( INSERT, UPDATE ou DELETE )
    IF INSERTING THEN
        operacao := 'INSERT';
    ELSIF UPDATING THEN
        operacao := 'UPDATE';
    ELSIF DELETING THEN
        operacao := 'DELETE';
    END IF;
    
    -- Obtém o nome de usuário da sessão atual
    nome_usuario := SYS_CONTEXT ('USERENV', 'SESSION_USER');
    
    -- Registra a auditoria na tabela de auditoria
    INSERT INTO tb_auditoria
        ( tabela, operacao, data, usuario)
    VALUES
        ( 'pedido_novos', operacao, sysdate, nome_usuario);
END;

-------- Inserindo dados novos --------

INSERT INTO pedido_novos (
    cod_pedido,
    cod_cliente
) VALUES ( 1533,
           70 );

-------- Select na auditoria --------

SELECT * FROM tb_auditoria;


-------- Exercicio --------

SET SERVEROUTPUT ON;

-- 1. Crie uma trigger para registrar as alterações de DATA DE ENREGA na tabela PEDIDO.
SELECT * FROM pedido;

CREATE OR REPLACE TRIGGER trg_alt_data_pedido
    BEFORE UPDATE ON pedido
    FOR EACH ROW
BEGIN
    IF :old.dat_entrega != :new.dat_entrega THEN
    DBMS_OUTPUT.PUT_LINE('Data de entrega alterada');
    END IF;
END;

UPDATE pedido 
    SET
        dat_entrega = TO_DATE('2025-08-09', 'YYYY-MM-DD')
WHERE
    cod_pedido = 130501;


-- 2. Crie uma trigger que consulta a quantidade de itens na tabela ITEM_PEDIDO e some o total de produto do mesmo pedido, 
-- caso esse total seja maior que 20 itens aplique um desconto automático que 20%.
SELECT * FROM item_pedido;

CREATE OR REPLACE TRIGGER trg_desconto
    AFTER INSERT ON item_pedido
    FOR EACH ROW
DECLARE
    qtd_item NUMBER;
BEGIN
    SELECT COUNT(*) INTO qtd_item
    FROM item_pedido;
    

    


-- 3. Crie uma trigger em na tabela de clientes para validar se CPF/CNPJ contenha somente valores numéricos.