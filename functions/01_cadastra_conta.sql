CREATE OR REPLACE FUNCTION cadastra_conta(pcNome TEXT,pnSaldo NUMERIC)
RETURNS conta AS $$
DECLARE
    rConta conta;
BEGIN
    INSERT INTO conta (nome,saldo)
        VALUES(pcNome,pnSaldo)
        RETURNING * INTO rConta;

RETURN rConta; 

END;
$$ LANGUAGE 'plpgsql';