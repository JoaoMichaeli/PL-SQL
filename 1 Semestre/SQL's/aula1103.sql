@ 'C:\Users\labsfiap\Desktop\ORACLE\SCRIPT_MODELO_PEDIDO(1).SQL';



ALTER TABLE CIDADE MODIFY NOM_CIDADE VARCHAR2(50);
ALTER TABLE PEDIDO ADD STATUS VARCHAR2(50);

insert into pais select * from pf1788.pais;
COMMIT;
insert into estado select * from pf1788.estado;
COMMIT;

insert into cidade select * from pf1788.cidade;
COMMIT;

insert into endereco_cliente select * from pf1788.endereco_cliente;
COMMIT;

insert into usuario select * from pf1788.usuario;
COMMIT;

insert into tipo_endereco select * from pf1788.tipo_endereco;
COMMIT;

insert into estoque select * from pf1788.estoque;
COMMIT;

insert into ESTOQUE_PRODUTO select * from pf1788.estoque_produto;
COMMIT; // erro

insert into tipo_movimento_estoque select * from pf1788.tipo_movimento_estoque;
COMMIT;

insert into produto_composto select * from pf1788.produto_composto;
COMMIT; // erro

insert into cliente select * from pf1788.cliente;
COMMIT;

insert into vendedor select * from pf1788.vendedor;
COMMIT;

insert into historico_pedido select * from pf1788.historico_pedido;
COMMIT; //erro

insert into cliente_vendedor select * from pf1788.cliente_vendedor;
COMMIT;

insert into pedido select * from pf1788.pedido;
COMMIT;

insert into item_pedido select * from pf1788.item_pedido;
COMMIT; //erro

insert into produto select * from pf1788.produto;
COMMIT;

insert into produto_composto select * from pf1788.produto_composto;
COMMIT;

insert into estoque_produto select * from pf1788.estoque_produto;
COMMIT;