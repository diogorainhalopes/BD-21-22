#!/usr/bin/python3

from wsgiref.handlers import CGIHandler
from flask import Flask
from flask import render_template, request, redirect, url_for

## Libs postgres
import psycopg2
import psycopg2.extras

app = Flask(__name__)

## SGBD configs
DB_HOST="db.tecnico.ulisboa.pt"
DB_USER="UNDEFINED"
DB_DATABASE=DB_USER
DB_PASSWORD="UNDEFINED"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)


## Runs the function once the root page is requested.
## The request comes with the folder structure setting ~/web as the root
@app.route('/')
def index():
  try:
    return render_template("index.html", params=request.args)
  except Exception as e:
    return str(e)

@app.route('/menu')
def menu_principal():
  try:
    return render_template("index.html", params=request.args)
  except Exception as e:
    return str(e)

@app.route('/erro')
def erro():
  try:
    return render_template("erro.html", params=request.args)
  except Exception as e:
    return str(e)

@app.route('/categorias')
def editar_categorias():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT c.nome FROM categoria as c;"
    cursor.execute(query)
    return render_template("categorias.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()

@app.route('/retalhistas')
def editar_retalhista():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT * FROM retalhista;"
    cursor.execute(query)
    return render_template("retalhistas.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()


@app.route('/ivms')
def editar_ivms():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT * FROM ivm;"
    cursor.execute(query)
    return render_template("ivms.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()



@app.route('/categorias/simples')
def editar_simples():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT c.nome FROM categoria_simples as c;"
    cursor.execute(query)
    return render_template("simples.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()

@app.route('/categorias/super')
def editar_super():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT c.nome FROM super_categoria as c;"
    cursor.execute(query)
    return render_template("super.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()

@app.route('/categorias/super/sub_categorias')
def editar_sub():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    lista = request.args["nome"]
    query = "SELECT categoria FROM tem_outra WHERE super_categoria = %s;"
    data = (lista, )
    cursor.execute(query, data)
    return render_template("sub_cat.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()

@app.route('/categorias/simples/inserir')
def inserir_categoria_simples():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT * FROM categoria_simples;"
    cursor.execute(query)
    return render_template("inserir_cat_simples.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()

@app.route('/categorias/super/inserir')
def inserir_categoria_super():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT * FROM super_categoria;"
    cursor.execute(query)
    return render_template("inserir_cat_super.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()



@app.route('/retalhistas/inserir')
def inserir_retalhista():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT * FROM retalhista;"
    cursor.execute(query)
    return render_template("inserir_retalhista.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()

@app.route('/retalhistas/execute_insert', methods=["POST"])
def insert_retalhista_intoDB():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "INSERT INTO retalhista VALUES (%s, %s);"
    data = (request.form["tin"], request.form["nome"],)
    cursor.execute(query, data)
    return redirect(url_for('editar_retalhistas'))
  except Exception as e:
    return redirect(url_for('erro'))
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()

@app.route('/categorias/simples/execute_insert', methods=["POST"])
def insert_simple_cat_intoDB():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "INSERT INTO categoria VALUES (%s);"
    query2 = "INSERT INTO categoria_simples VALUES (%s);"
    query3 = "INSERT INTO tem_outra VALUES (%s, %s);"
    data = (request.form["nome"],)
    data2 = (request.form["super"],request.form["nome"],)
    cursor.execute(query, data)
    cursor.execute(query2, data)
    cursor.execute(query3, data2)
    return redirect(url_for('editar_simples'))
  except Exception as e:
    return redirect(url_for('erro'))
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()

@app.route('/categorias/super/execute_insert', methods=["POST"])
def insert_super_cat_intoDB():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "INSERT INTO categoria VALUES (%s);"
    query2 = "INSERT INTO super_categoria VALUES (%s);"
    data = (request.form["nome"],)
    cursor.execute(query, data)
    cursor.execute(query2, data)
    return redirect(url_for('editar_super'))
  except Exception as e:
    return redirect(url_for('erro'))
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()


@app.route('/ivms/listar_eventos')
def show_events_fromDB():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    lista = request.args["num_serie"]
    query = "SELECT ev.instante, ev.unidades, p.descr, p.cat FROM evento_reposicao AS ev, produto AS p WHERE p.ean = ev.ean AND ev.num_serie= %s;"
    data = (lista, )
    cursor.execute(query, data)
    return render_template("eventos_reposicao.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()


@app.route('/retalhistas/perform_delete')
def delete_retalhistas_fromDB():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    lista = request.args["tin"]
    query = "DELETE FROM retalhista WHERE tin = %s;"
    data = (lista,)
    cursor.execute(query, data)
    return redirect(url_for('editar_retalhista'))
  except Exception as e:
    return str(e)
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()

@app.route('/categorias/simples/perform_delete')
def delete_simples_fromDB():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    lista = request.args["nome"]
    query = "DELETE FROM categoria WHERE nome = %s;"
    data = (lista,)
    cursor.execute(query, data)
    return redirect(url_for('editar_simples'))
  except Exception as e:
    return str(e)
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()

@app.route('/categorias/super/perform_delete')
def delete_venda_fromDB():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    lista = request.args["nome"]
    query = "DELETE FROM categoria WHERE nome = %s;"
    data = (lista,)
    cursor.execute(query,data)
    return redirect(url_for('editar_super'))
  except Exception as e:
    return str(e)
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()


CGIHandler().run(app)
