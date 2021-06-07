defmodule Migracion_investigacion do

  import Utils

  def cargar_investigacion() do

    query_sql = "SELECT
        menu_links.mlid AS mlid,
        menu_links.link_title AS titulo
      FROM menu_links
      WHERE menu_links.mlid = 1161;"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows

  end


  def cargar_hijos(plid) do

    query_sql =
    "SELECT
      menu_links.mlid AS mlid,
      menu_links.link_title AS titulo,
      REPLACE(menu_links.link_path, 'node/','') AS nid,
      menu_links.has_children AS tiene_hijos
    FROM menu_links
    WHERE menu_links.plid = " <> to_string(plid) <>
    " AND menu_links.router_path= 'node/%';"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows

  end

  def cargar_nodo(nid) do

    query_sql = "SELECT
        node.title AS titulo_nodo,
        field_data_body.body_value AS texto_asociado
      FROM node
      LEFT JOIN field_data_body ON field_data_body.entity_id = node.nid
      WHERE node.nid = " <> to_string(nid) <> ";"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows

  end

  def investigacion_recursivo(elemento, url_nav_padre, nombre_nav_padre) do

    nid = elemento |> Enum.at(2)
    nodo = cargar_nodo(nid) |> Enum.at(0)

    titulo = nodo |> Enum.at(0)
    #texto = nodo |> Enum.at(1)

    #IO.puts(titulo)

    #id_pagina = crear_pagina(titulo, texto)

    #nombre_nav = nombre_nav_padre <> " - " <> titulo
    #url_nav = url_nav_padre <> (titulo |> url_format()) <> "/"

    #crear_navegacion(url,nombre_nav, id_pagina)

    #Si tiene hijos (elemento |> Enum.at(3) == 1)
    #if(elemento |> Enum.at(3) == 1) do

    #  hijos = elemento |> Enum.at(0) |> cargar_hijos
    #  Enum.map(
    #    hijos,
    #    fn hijo ->
    #      investigacion_recursivo(hijo, url_nav, nombre_nav)
    #    end
    #  )
    #end

  end



  def investigacion() do

    investigacion = cargar_investigacion() |> Enum.at(0)

    texto_pagina= ""
    nombre_pagina = "Investigación"

    #id_pagina_investigacion = crear_pagina(nombre_pagina, texto_pagina)

    url_investigacion = "/investigacion/"
    #crear_navegacion(url_investigacion, nombre_pagina, id_pagina_investigacion)

    investigaciones = investigacion |> Enum.at(0) |> cargar_hijos()
    Enum.map(
      investigaciones,
      fn elemento ->
        investigacion_recursivo(elemento,url_investigacion,nombre_pagina)
      end
    )
  end


end
