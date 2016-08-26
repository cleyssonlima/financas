CREATE OR REPLACE FUNCTION cadastra_despesa(pnValor NUMERIC, pcConta TEXT, pcCategoria TEXT, pcDescricao TEXT)
RETURNS lancamento AS $$
DECLARE
  -- pnValor ALIAS FOR $1;
  nCodigoCategoria INT;
  nCodigoConta INT;
	  lRetorno	lancamento;
BEGIN

	SELECT INTO nCodigoConta
		id
	FROM conta
	WHERE UPPER(nome) = UPPER(pcConta);

	IF NOT FOUND THEN
		RAISE EXCEPTION 'Fudeu! Não achei a conta!';
	END IF;

	SELECT INTO nCodigoCategoria
		id
	FROM categoria
	WHERE UPPER(nome) = UPPER(pcCategoria);

	IF NOT FOUND THEN
		--RAISE EXCEPTION 'Fudeu! Não achei a categoria!';
		RAISE WARNING 'Não achei a categoria, cadastrando nova.';
		insert into categoria (nome) 
			values (pcCategoria)
			RETURNING id into nCodigoCategoria;
	END IF;


	INSERT INTO lancamento (valor, conta_id, categoria_id, descricao) 
		VALUES (pnValor, nCodigoConta, nCodigoCategoria, pcDescricao)
		RETURNING * INTO lRetorno;

	RETURN lRetorno;

END;
$$ LANGUAGE 'plpgsql';
