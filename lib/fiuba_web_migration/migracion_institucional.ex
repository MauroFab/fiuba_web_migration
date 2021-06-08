defmodule Migracion_institucional do

  import Utils

  alias FiubaWebMigration.Repo
  import Ecto.Query
  import JSON
  import String

  def cargar_institucional() do

    query_sql = "SELECT
        menu_links.mlid AS mlid,
        menu_links.link_title AS titulo
      FROM menu_links
      WHERE menu_links.mlid = 1225;"

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


  def institucional_recursivo(elemento, url_nav_padre, nombre_nav_padre) do

    nid = elemento |> Enum.at(2)
    nodo = cargar_nodo(nid) |> Enum.at(0)

    titulo = nodo |> Enum.at(0)
    texto = nodo |> Enum.at(1)

    id_pagina = crear_pagina(titulo, texto)

    nombre_nav = nombre_nav_padre <> " - " <> titulo
    url_nav = url_nav_padre <> "/" <> (titulo |> url_format())

    crear_navegacion(url_nav,nombre_nav, id_pagina)

    # 1 = Tiene hijos, 0 = No tiene hijos
    has_children = elemento |> Enum.at(3)

    if (has_children == 1) do
      hijos = elemento |> Enum.at(0) |> cargar_hijos
      Enum.map(
        hijos,
        fn hijo ->
          institucional_recursivo(hijo,url_nav,nombre_nav)
        end
      )
    end
  end


  def institucional() do

    institucional = cargar_institucional() |> Enum.at(0)

    texto_pagina= ""
    nombre_pagina = "Institucional"

    id_pagina_institucional = crear_pagina(nombre_pagina, texto_pagina)

    url_institucional = "/institucional"
    crear_navegacion(url_institucional, nombre_pagina, id_pagina_institucional)

    institucionales= institucional |> Enum.at(0) |> cargar_hijos()
    Enum.map(
      institucionales,
      fn elemento ->
        institucional_recursivo(elemento,url_institucional,nombre_pagina)
      end
    )
  end


end
