DROP TRIGGER IF EXISTS verifica_cat_recursao ON tem_outra;
DROP TRIGGER IF EXISTS verifica_nr_unid_repostas ON evento_reposicao;
DROP TRIGGER IF EXISTS verifica_cat_produto ON evento_reposicao;



CREATE OR REPLACE FUNCTION verifica_cat_recursao_trigger_proc() RETURNS TRIGGER AS $$

BEGIN
    IF new.categoria = new.super_categoria THEN
        RAISE EXCEPTION 'Uma Categoria não pode estar contida em si própria';
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verifica_cat_recursao BEFORE INSERT OR UPDATE ON tem_outra
FOR EACH ROW EXECUTE FUNCTION verifica_cat_recursao_trigger_proc();

---------------



CREATE OR REPLACE FUNCTION verifica_nr_unid_repostas_trigger_proc() RETURNS TRIGGER AS $$
DECLARE new_units INTEGER := 0;
DECLARE prev_units INTEGER := 0;
BEGIN
    SELECT new.unidades INTO new_units, planograma.unidades INTO prev_units
    FROM planograma
    WHERE planograma.ean = new.ean AND planograma.nro = new.nro AND planograma.num_serie = new.num_serie 
    AND planograma.fabricante = new.fabricante
    IF new_units > prev_units OR new_units < 0  THEN
        RAISE EXCEPTION 'O nr de unidades repostas num Evento de Reposicao nao pode exceder o numero de unidades especificado no Planograma ou ser inferior a 0';
    END IF;
    RETURN new; 

END
$$ LANGUAGE plpgsql;

CREATE TRIGGER verifica_nr_unid_repostas BEFORE INSERT OR UPDATE ON evento_reposicao
FOR EACH ROW EXECUTE FUNCTION verifica_nr_unid_repostas_trigger_proc();

-----------
CREATE OR REPLACE FUNCTION verifica_cat_produto_trigger_proc() RETURNS TRIGGER AS $$
BEGIN
    
    IF new.ean NOT IN (
        SELECT ean
        FROM tem_categoria NATURAL JOIN prateleira
        WHERE nro = new.nro AND num_serie = new.num_serie AND fabricante = new.fabricante
    ) THEN
        RAISE EXCEPTION 'Um  Produto  so  pode  ser  reposto  numa  Prateleira  que  apresente  (pelo  menos)  uma  das Categorias desse produto.';
    END IF;
    RETURN new;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verifica_cat_produto BEFORE INSERT OR UPDATE ON evento_reposicao
FOR EACH ROW EXECUTE FUNCTION verifica_cat_produto_trigger_proc();


--Delete Cascades:
DROP TRIGGER IF EXISTS cascade_on_delete_categoria ON categoria;
CREATE OR REPLACE FUNCTION cascade_on_delete_categoria() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM categoria_simples WHERE nome = old.nome;
    DELETE FROM super_categoria WHERE nome = old.nome;
    DELETE FROM tem_outra WHERE categoria = old.nome;
    DELETE FROM produto WHERE cat = old.nome;
    DELETE FROM tem_categoria WHERE nome = old.nome;
    DELETE FROM prateleira WHERE nome = old.nome;
    DELETE FROM responsavel_por WHERE nome_cat = old.nome;
    RETURN old;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER cascade_on_delete_categoria BEFORE DELETE ON categoria
FOR EACH ROW EXECUTE FUNCTION cascade_on_delete_categoria();
-----------

DROP TRIGGER IF EXISTS cascade_on_delete_super_categoria ON super_categoria;
CREATE OR REPLACE FUNCTION cascade_on_delete_super_categoria() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM tem_outra WHERE super_categoria = old.nome;
    RETURN old;

END
$$ LANGUAGE plpgsql;

CREATE TRIGGER cascade_on_delete_super_categoria BEFORE DELETE ON super_categoria
FOR EACH ROW EXECUTE FUNCTION cascade_on_delete_super_categoria();

-----------

DROP TRIGGER IF EXISTS cascade_on_delete_categoria_simples ON categoria_simples;
CREATE OR REPLACE FUNCTION cascade_on_delete_categoria_simples() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM tem_outra WHERE categoria = old.nome;
    RETURN old;

END
$$ LANGUAGE plpgsql;

CREATE TRIGGER cascade_on_delete_categoria_simples BEFORE DELETE ON categoria_simples
FOR EACH ROW EXECUTE FUNCTION cascade_on_delete_categoria_simples();

----------
DROP TRIGGER IF EXISTS cascade_on_delete_produto ON produto;
CREATE OR REPLACE FUNCTION cascade_on_delete_produto() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM tem_categoria WHERE ean = old.ean;
    DELETE FROM planograma WHERE ean = old.ean;
    RETURN old;

END
$$ LANGUAGE plpgsql;

CREATE TRIGGER cascade_on_delete_produto BEFORE DELETE ON produto
FOR EACH ROW EXECUTE FUNCTION cascade_on_delete_produto();
------------

DROP TRIGGER IF EXISTS cascade_on_delete_ivm ON ivm;
CREATE OR REPLACE FUNCTION cascade_on_delete_ivm() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM instalada_em WHERE num_serie = old.num_serie AND fabricante = old.fabricante;
    DELETE FROM prateleira WHERE num_serie = old.num_serie AND fabricante = old.fabricante;
    DELETE FROM responsavel_por WHERE num_serie = old.num_serie AND fabricante = old.fabricante;
    RETURN old;

END
$$ LANGUAGE plpgsql;

CREATE TRIGGER cascade_on_delete_ivm BEFORE DELETE ON ivm
FOR EACH ROW EXECUTE FUNCTION cascade_on_delete_ivm();

-----------------------

DROP TRIGGER IF EXISTS cascade_on_delete_ponto_de_retalho ON ponto_de_retalho;
CREATE OR REPLACE FUNCTION cascade_on_delete_ponto_de_retalho() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM instalada_em WHERE locale = old.nome;
    RETURN old;

END
$$ LANGUAGE plpgsql;

CREATE TRIGGER cascade_on_delete_ponto_de_retalho BEFORE DELETE ON ponto_de_retalho
FOR EACH ROW EXECUTE FUNCTION cascade_on_delete_ponto_de_retalho();
------------

DROP TRIGGER IF EXISTS cascade_on_delete_prateleira ON prateleira;
CREATE OR REPLACE FUNCTION cascade_on_delete_prateleira() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM planograma WHERE nro = old.nro AND num_serie = old.num_serie AND fabricante = old.fabricante;
    RETURN old;

END
$$ LANGUAGE plpgsql;

CREATE TRIGGER cascade_on_delete_prateleira BEFORE DELETE ON prateleira
FOR EACH ROW EXECUTE FUNCTION cascade_on_delete_prateleira();
------------

DROP TRIGGER IF EXISTS cascade_on_delete_planograma ON planograma;
CREATE OR REPLACE FUNCTION cascade_on_delete_planograma() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM evento_reposicao WHERE ean = old.ean AND nro = old.nro AND num_serie = old.num_serie AND fabricante = old.fabricante;
    RETURN old;

END
$$ LANGUAGE plpgsql;

CREATE TRIGGER cascade_on_delete_planograma BEFORE DELETE ON planograma
FOR EACH ROW EXECUTE FUNCTION cascade_on_delete_planograma();
---------------
DROP TRIGGER IF EXISTS cascade_on_delete_retalhista ON retalhista;
CREATE OR REPLACE FUNCTION cascade_on_delete_retalhista() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM responsavel_por WHERE tin = old.tin;
    DELETE FROM evento_reposicao WHERE tin = old.tin;
    RETURN old;

END
$$ LANGUAGE plpgsql;

CREATE TRIGGER cascade_on_delete_retalhista BEFORE DELETE ON retalhista
FOR EACH ROW EXECUTE FUNCTION cascade_on_delete_retalhista();


