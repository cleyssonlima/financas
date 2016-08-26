CREATE OR REPLACE FUNCTION trg_atualiza_lancamento()
RETURNS TRIGGER AS $$
DECLARE
	rDadosConta RECORD;
	nNovoValor NUMERIC;

BEGIN

	-- computa novo valor
	IF TG_OP = 'INSERT' THEN
		nNovoValor = NEW.valor;
	ELSIF TG_OP = 'UPDATE' THEN
        nNovoValor = NEW.valor - OLD.valor;
    ELSIF TG_OP = 'DELETE' THEN
    	nNovoValor = OLD.valor;
	END IF;

	-- TESTA SE TEM SALDO
	IF TG_OP IN ('INSERT', 'UPDATE') THEN
		SELECT INTO rDadosConta
			*
		FROM conta
		WHERE conta.id = new.conta_id;

		RAISE notice 'nNovoValor: %', nNovoValor;
		RAISE notice 'rDadosConta.saldo: %', rDadosConta.saldo; 

		IF nNovoValor > rDadosConta.saldo THEN
			RAISE EXCEPTION 'Saldo insuficiente';

		END IF;
	END IF;


	IF TG_OP = 'INSERT' THEN

		UPDATE conta SET saldo = saldo - nNovoValor
		WHERE id = NEW.conta_id;
		RETURN NEW;

	ELSIF TG_OP IN ('UPDATE', 'DELETE') THEN
		UPDATE conta SET saldo = saldo + nNovoValor
		WHERE id = OLD.conta_id;

		IF TG_OP  = 'UPDATE' THEN
			RETURN NEW;
		ELSE 
			RETURN OLD;
		END IF;

	END IF;


END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS trg_atualiza_saldo ON lancamento;

CREATE TRIGGER trg_atualiza_saldo 
BEFORE INSERT OR UPDATE OR DELETE ON lancamento
FOR EACH ROW EXECUTE PROCEDURE trg_atualiza_lancamento();