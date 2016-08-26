CREATE EXTENSION IF NOT EXISTS plpgsql;

DROP  TABLE IF EXISTS lancamento CASCADE;

CREATE TABLE lancamento (
    id SERIAL PRIMARY KEY,
    valor numeric(7,2),
    conta_id integer,
    categoria_id integer,
    dtlancamento timestamp without time zone DEFAULT now(),
    descricao text,
    CONSTRAINT lancamento_valor_check CHECK ((valor > (0)::numeric))
);


DROP  TABLE IF EXISTS categoria CASCADE;

CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
    nome text
);

DROP  TABLE IF EXISTS conta CASCADE;

CREATE TABLE conta (
    id SERIAL PRIMARY KEY,
    nome text,
    saldo numeric(7,2)
);