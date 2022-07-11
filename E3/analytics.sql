/*Indexs - Isto é para o relatorio*/

--1
create index i1 on responsavel_por using hash(nome_cat);

--2

create index i2 on tem_categoria(nome);
create index i3 on produto using hash(cat);

/*OLAP*/

--1

select dia_semana, concelho, sum(unidades)
from vendas
where DATEFROMPARTS(ano, mes, dia_mes) >= DATEFROMPARTS(2012, 3, 12) AND 
      DATEFROMPARTS(ano, mes, dia_mes) <= DATEFROMPARTS(2010, 7, 21)
group by cube (dia_semana, concelho); 
--cube ou grouping sets ((dia_semana), (concelho), ())

--2

select concelho, cat, dia_semana, sum(unidades)
from vendas
where distrito = 'Lisboa'
group by cube(concelho, cat, dia_semana);
--cube ou grouping sets ((concelho), (cat), (dia_semana), ())
