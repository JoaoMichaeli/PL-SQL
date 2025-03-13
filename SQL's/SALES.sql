SELECT * FROM sales;

-- Criar um bloco para trazer a quantidade de pedidos por país

DECLARE
    v_pais VARCHAR2(50) := '&PAIS';
    v_pedidos NUMBER;
    v_faturamento NUMBER;
BEGIN
    SELECT COUNT(1) INTO v_pedidos FROM sales WHERE country = (v_pais);
    SELECT SUM(priceeach) INTO v_faturamento FROM sales WHERE country = (v_pais);
    dbms_output.put_line('País selecionado: ' || v_pais);
    dbms_output.put_line('Quantidade de pedidos: ' || v_pedidos);
    dbms_output.put_line('Faturamento: ' || v_faturamento);
END;