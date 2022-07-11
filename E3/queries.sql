/*1 Qual o nome do retalhista (ou retalhistas)  responsáveis pela reposição do maior número de 
categorias?  */
select nome 
from (
    select nome, count(distinct nome_cat) /*distinct*/
    from retalhista natural join responsavel_por
    group by tin
    having count(distinct nome_cat) >= all(
        select count(distinct nome_cat)
        from retalhista natural join responsavel_por /*da para reutilizar esta parte em cima ?*/
        group by tin
    )
) as lista;

/*2 Qual o nome do ou dos retalhistas que são responsáveis por todas as categorias simples? */
select retalhista.nome
from categoria_simples join responsavel_por on categoria_simples.nome = responsavel_por.nome_cat
join retalhista on retalhista.tin = responsavel_por.tin
group by retalhista.nome


/*3 Quais os produtos (ean) que nunca foram repostos? */
select ean
from produto
where ean not in (
    select ean from evento_reposicao
);

/*4 Quais os produtos (ean) que foram repostos sempre pelo mesmo retalhista? */
select ean
from (
    select ean, count(distinct tin) /*necessário este count ?? */
    from evento_reposicao
    group by ean
    having count(distinct tin) = 1
) as lista;

