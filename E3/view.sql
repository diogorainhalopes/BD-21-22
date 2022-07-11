create view vendas(ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades) as
    select ean, cat, 
        extract(year from instante) as ano, extract(quarter from instante) as trimestre,
        extract(month from instante) as mes, extract(day from instante) as dia_mes, 
        extract(dow from instante) as dia_semana, distrito, concelho, unidades
    from (produto natural join evento_reposicao natural join instalada_em) j1 join ponto_de_retalho pr on j1.locale = pr.nome; 