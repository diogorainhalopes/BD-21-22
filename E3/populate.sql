drop table if exists categoria;
drop table if exists categoria_simples;
drop table if exists super_categoria;
drop table if exists tem_outra;
drop table if exists produto;
drop table if exists tem_categoria;
drop table if exists IVM;
drop table if exists ponto_de_retalho;
drop table if exists instalada_em;
drop table if exists prateleira;
drop table if exists planograma;
drop table if exists retalhista;
drop table if exists responsavel_por;
drop table if exists evento_reposicao;



-- TODO: Rever not nulls e tipos
-- check a seguir a declaracao do atributo ??

create table categoria (
    nome varchar(255) not null,
    primary key (nome)
);

create table categoria_simples (
  nome varchar(255) not null,
  primary key (nome),
  foreign key (nome) references categoria(nome)
);

create table super_categoria (
  nome varchar(255) not null,
  primary key (nome),
  foreign key (nome) references categoria(nome)
);

create table tem_outra (
    super_categoria varchar(255) not null,
    categoria varchar(255) not null,
    primary key (categoria),
    foreign key (categoria) references categoria(nome),
    foreign key (super_categoria) references super_categoria(nome),
    unique (super_categoria, categoria) --RI-RE4
);

create table produto (
    ean numeric(13, 0) not null,
    cat varchar(255) not null,
    descr varchar(255),/*pode ser null ?? */
    primary key (ean),
    foreign key (cat) references categoria(nome)
);

create table tem_categoria ( /*nao tem primary ??*/
    ean numeric(13, 0) not null,
    nome varchar(255) not null,
    foreign key (nome) references categoria(nome),
    foreign key (ean) references produto(ean)
);

create table IVM (
    num_serie integer not null,
    fabricante varchar(255) not null, /*char?*/
    primary key (num_serie, fabricante)
);

create table ponto_de_retalho (
    nome varchar(255) not null,
    distrito varchar(255),
    concelho varchar(255),/*podem ser null ??*/
    primary key (nome)
);

create table instalada_em (
    num_serie integer not null,
    fabricante varchar(255) not null,
    locale varchar(255),/*null?? local->é keyword?*/
    primary key (num_serie, fabricante),
    foreign key (num_serie, fabricante) references IVM(num_serie, fabricante),
    foreign key (locale) references ponto_de_retalho(nome)
);

create table prateleira (
    nro integer not null,
    num_serie integer not null,
    fabricante varchar(255) not null,
    altura integer not null,
    nome varchar(255) not null,
    primary key (nro, num_serie, fabricante),
    foreign key (num_serie, fabricante) references IVM(num_serie, fabricante),
    foreign key (nome) references categoria(nome)
);

create table planograma (
    ean numeric(13, 0) not null,
    nro integer not null,
    num_serie integer not null,
    fabricante varchar(255) not null,
    faces integer not null,
    unidades integer not null,
    loc varchar(255) not null, /*null ? */
    primary key (ean, nro, num_serie, fabricante),
    foreign key (ean) references produto(ean),
    foreign key (nro, num_serie, fabricante) references prateleira(nro, num_serie, fabricante)
);

create table retalhista (
    tin integer not null, /*int or char?? */
    nome varchar(255) not null,
    primary key (tin),
    unique (nome) --RI-RE7
);

create table responsavel_por (
    nome_cat varchar(255) not null,
    tin integer not null,
    num_serie integer not null,
    fabricante varchar(255) not null,
    primary key (nome_cat, num_serie, fabricante),
    foreign key (nome_cat) references categoria(nome),
    foreign key (tin) references retalhista(tin),
    foreign key (num_serie, fabricante) references IVM(num_serie, fabricante)

);

create table evento_reposicao (
    ean numeric(13, 0) not null,
    nro integer not null,
    num_serie integer not null,
    fabricante varchar(255) not null,
    instante timestamp not null,
    unidades integer not null,
    tin integer not null,
    primary key (ean, nro, num_serie, fabricante, instante),
    foreign key (ean, nro, num_serie, fabricante) references planograma(ean, nro, num_serie, fabricante),
    foreign key (tin) references retalhista(tin)
);



INSERT INTO categoria VALUES ('Bebidas');
INSERT INTO categoria VALUES ('Lacticinios');
INSERT INTO categoria VALUES ('Chocolate');
INSERT INTO categoria VALUES ('Sandes');
insert into categoria VALUES ('Iogurte');
INSERT INTO categoria VALUES ('Agua');

INSERT INTO categoria_simples VALUES ('Chocolate');
INSERT INTO categoria_simples VALUES ('Sandes');
INSERT INTO categoria_simples VALUES ('Iogurte');
INSERT INTO categoria_simples VALUES ('Agua');

INSERT INTO super_categoria VALUES ('Bebidas');
INSERT INTO super_categoria VALUES ('Lacticinios');

INSERT INTO tem_outra VALUES ('Bebidas', 'Agua');
INSERT INTO tem_outra VALUES ('Lacticinios', 'Iogurte');

INSERT INTO produto VALUES ('1111111111001', 'Chocolate', 'Chocolate Preto');
INSERT INTO produto VALUES ('1111111111002', 'Chocolate', 'Chocolate Branco');
INSERT INTO produto VALUES ('1111111111003', 'Sandes', 'Tosta Mista');
INSERT INTO produto VALUES ('1111111111004', 'Sandes', 'Panado');
INSERT INTO produto VALUES ('1111111111005', 'Iogurte', 'Danoninhos');
INSERT INTO produto VALUES ('1111111111006', 'Iogurte', 'Iogurte Natural');
INSERT INTO produto VALUES ('1111111111007', 'Agua', 'Monchique');
INSERT INTO produto VALUES ('1111111111008', 'Bebidas', 'RedBull');
INSERT INTO produto VALUES ('1111111111009', 'Bebidas', 'Monster');
INSERT INTO produto VALUES ('1111111111010', 'Lacticinios', 'Babybel');

INSERT INTO tem_categoria VALUES ('1111111111001', 'Chocolate');
INSERT INTO tem_categoria VALUES ('1111111111002', 'Chocolate');
INSERT INTO tem_categoria VALUES ('1111111111003', 'Sandes');
INSERT INTO tem_categoria VALUES ('1111111111004', 'Sandes');
INSERT INTO tem_categoria VALUES ('1111111111005', 'Iogurte');
INSERT INTO tem_categoria VALUES ('1111111111006', 'Iogurte');
INSERT INTO tem_categoria VALUES ('1111111111007', 'Agua');
INSERT INTO tem_categoria VALUES ('1111111111008', 'Bebidas');
INSERT INTO tem_categoria VALUES ('1111111111009', 'Bebidas');
INSERT INTO tem_categoria VALUES ('1111111111010', 'Lacticinios');

INSERT INTO IVM VALUES ('1234', 'ReleaseNStay');
INSERT INTO IVM VALUES ('4321', 'TakeIn');

INSERT INTO ponto_de_retalho VALUES ('AlegroSintra', 'Lisboa', 'Sintra');
INSERT INTO ponto_de_retalho VALUES ('AlegroGaia', 'Porto', 'Gaia');

INSERT INTO instalada_em VALUES ('1234', 'ReleaseNStay', 'AlegroSintra');
INSERT INTO instalada_em VALUES ('4321', 'TakeIn', 'AlegroGaia');

INSERT INTO prateleira VALUES ('1', '1234', 'ReleaseNStay', '10', 'Bebidas');
INSERT INTO prateleira VALUES ('2', '1234', 'ReleaseNStay', '20', 'Lacticinios');
INSERT INTO prateleira VALUES ('3', '1234', 'ReleaseNStay', '30', 'Chocolate');
INSERT INTO prateleira VALUES ('4', '1234', 'ReleaseNStay', '40', 'Sandes');
INSERT INTO prateleira VALUES ('5', '1234', 'ReleaseNStay', '50', 'Iogurte');
INSERT INTO prateleira VALUES ('6', '1234', 'ReleaseNStay', '60', 'Agua');

INSERT INTO prateleira VALUES ('1', '4321', 'TakeIn', '10', 'Bebidas');
INSERT INTO prateleira VALUES ('2', '4321', 'TakeIn', '20', 'Lacticinios');
INSERT INTO prateleira VALUES ('3', '4321', 'TakeIn', '30', 'Chocolate');
INSERT INTO prateleira VALUES ('4', '4321', 'TakeIn', '40', 'Sandes');
INSERT INTO prateleira VALUES ('5', '4321', 'TakeIn', '50', 'Iogurte');
INSERT INTO prateleira VALUES ('6', '4321', 'TakeIn', '60', 'Agua');

INSERT INTO planograma VALUES ('1111111111001', '3', '1234', 'ReleaseNStay', '1', '10', '0');
INSERT INTO planograma VALUES ('1111111111002', '3', '1234', 'ReleaseNStay', '2', '15', '0');
INSERT INTO planograma VALUES ('1111111111003', '4', '1234', 'ReleaseNStay', '3', '5', '0');
INSERT INTO planograma VALUES ('1111111111004', '4', '1234', 'ReleaseNStay', '2', '8', '0');
INSERT INTO planograma VALUES ('1111111111005', '5', '1234', 'ReleaseNStay', '1', '20', '0');
INSERT INTO planograma VALUES ('1111111111006', '5', '1234', 'ReleaseNStay', '1', '20', '0');
INSERT INTO planograma VALUES ('1111111111007', '6', '1234', 'ReleaseNStay', '1', '20', '0');
INSERT INTO planograma VALUES ('1111111111008', '1', '1234', 'ReleaseNStay', '1', '20', '0');
INSERT INTO planograma VALUES ('1111111111009', '1', '1234', 'ReleaseNStay', '1', '20', '0');
INSERT INTO planograma VALUES ('1111111111010', '2', '1234', 'ReleaseNStay', '1', '10', '0');

INSERT INTO planograma VALUES ('1111111111001', '3', '4321', 'TakeIn', '1', '10', '0');
INSERT INTO planograma VALUES ('1111111111002', '3', '4321', 'TakeIn', '2', '15', '0');
INSERT INTO planograma VALUES ('1111111111003', '4', '4321', 'TakeIn', '3', '5', '0');
INSERT INTO planograma VALUES ('1111111111004', '4', '4321', 'TakeIn', '2', '8', '0');
INSERT INTO planograma VALUES ('1111111111005', '5', '4321', 'TakeIn', '1', '20', '0');
INSERT INTO planograma VALUES ('1111111111006', '5', '4321', 'TakeIn', '1', '20', '0');
INSERT INTO planograma VALUES ('1111111111007', '6', '4321', 'TakeIn', '1', '20', '0');
INSERT INTO planograma VALUES ('1111111111008', '1', '4321', 'TakeIn', '1', '20', '0');
INSERT INTO planograma VALUES ('1111111111009', '1', '4321', 'TakeIn', '1', '20', '0');
INSERT INTO planograma VALUES ('1111111111010', '2', '4321', 'TakeIn', '1', '10', '0');

INSERT INTO retalhista VALUES ('99999', 'Muhammad');
INSERT INTO retalhista VALUES ('88888', 'Xin');

INSERT INTO responsavel_por VALUES('Bebidas', '99999', '1234', 'ReleaseNStay');
INSERT INTO responsavel_por VALUES('Lacticinios', '99999', '1234', 'ReleaseNStay');
INSERT INTO responsavel_por VALUES('Chocolate', '99999', '1234', 'ReleaseNStay');
INSERT INTO responsavel_por VALUES('Sandes', '99999', '1234', 'ReleaseNStay');
INSERT INTO responsavel_por VALUES('Iogurte', '99999', '1234', 'ReleaseNStay');
INSERT INTO responsavel_por VALUES('Agua', '99999', '1234', 'ReleaseNStay');

INSERT INTO responsavel_por VALUES('Bebidas', '88888', '4321', 'TakeIn');
INSERT INTO responsavel_por VALUES('Lacticinios', '88888', '4321', 'TakeIn');
INSERT INTO responsavel_por VALUES('Chocolate', '88888', '4321', 'TakeIn');
INSERT INTO responsavel_por VALUES('Sandes', '88888', '4321', 'TakeIn');
INSERT INTO responsavel_por VALUES('Iogurte', '88888', '4321', 'TakeIn');
INSERT INTO responsavel_por VALUES('Agua', '88888', '4321', 'TakeIn');

INSERT INTO evento_reposicao VALUES('1111111111001', '3', '1234', 'ReleaseNStay', '2022-01-01 08:00:00', '4', '99999');
INSERT INTO evento_reposicao VALUES('1111111111004', '4', '1234', 'ReleaseNStay', '2022-01-02 09:00:00', '3', '99999');
INSERT INTO evento_reposicao VALUES('1111111111006', '5', '1234', 'ReleaseNStay', '2022-01-02 15:00:00', '3', '99999');

INSERT INTO evento_reposicao VALUES('1111111111006', '5', '4321', 'TakeIn', '2022-01-03 11:00:00', '2', '88888');
INSERT INTO evento_reposicao VALUES('1111111111009', '1', '4321', 'TakeIn', '2022-01-04 19:00:00', '11', '88888');