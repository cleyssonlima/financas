DROP VIEW IF EXISTS vw_lista_lancamentos;

CREATE VIEW vw_lista_lancamentos AS
 SELECT l.dtlancamento AS data,
    cc.nome AS conta,
    c.nome AS categoria,
    l.valor
   FROM ((lancamento l
     JOIN categoria c ON ((c.id = l.categoria_id)))
     JOIN conta cc ON ((cc.id = l.conta_id)));

