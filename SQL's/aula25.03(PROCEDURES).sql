SET SERVEROUTPUT ON;

INSERT INTO pais VALUES(24, 'Egito');
COMMIT;

SELECT * FROM pais;

DECLARE
    cod_pais NUMBER;
    nom_pais VARCHAR2(50);
BEGIN
    cod_pais := &cod_pais;
    nom_pais := '&nom_pais';
    INSERT INTO pais VALUES(cod_pais,nom_pais);
END;

-- PROCEDURES
CREATE OR REPLACE PROCEDURE prd_insert_pais (
    p_cod  NUMBER,
    p_nome VARCHAR2
) AS
BEGIN
    INSERT INTO pais VALUES (
        p_cod,
        p_nome
    );

    COMMIT;
END;