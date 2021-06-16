defmodule Migracion_institucional do
  import Utils

  # alias FiubaWebMigration.Repo
  # import Ecto.Query
  # import JSON
  # import String

  # def cargar_institucional() do

  #   query_sql =
  #     "SELECT
  #       menu_links.mlid AS mlid,
  #       menu_links.link_title AS titulo
  #     FROM menu_links
  #     WHERE menu_links.mlid = 1225;"

  #   {:ok, respuesta} = Repo.query(query_sql)
  #   respuesta.rows

  # end

  # def institucional_recursivo(elemento, url_nav_padre, nombre_nav_padre) do

  #   nid = elemento |> Enum.at(2)
  #   nodo = cargar_nodo(nid) |> Enum.at(0)

  #   titulo = nodo |> Enum.at(0)
  #   texto = nodo |> Enum.at(1)

  #   id_pagina = crear_pagina(titulo, texto)

  #   nombre_nav = nombre_nav_padre <> " - " <> titulo
  #   url_nav = url_nav_padre <> "/" <> (titulo |> url_format())

  #   crear_navegacion(url_nav,nombre_nav, id_pagina)

  #   # 1 = Tiene hijos, 0 = No tiene hijos
  #   has_children = elemento |> Enum.at(3)

  #   if (has_children == 1) do
  #     hijos = elemento |> Enum.at(0) |> cargar_hijos
  #     Enum.map(
  #       hijos,
  #       fn hijo ->
  #         institucional_recursivo(hijo,url_nav,nombre_nav)
  #       end
  #     )
  #   end
  # end

  def institucional() do

    # REQUIRE BORRAR UN REGISTRO EN MENU_LINKS: menu_links.link_path = 'node/1406'

    texto_pagina = ""
    nombre_pagina = "Institucional"
    jerarquia_institucional = nombre_pagina
    url_institucional = "/institucional"

    id_menu_lateral = crear_menu_lateral(url_institucional)
    id_pagina_institucional = crear_pagina(nombre_pagina, texto_pagina, jerarquia_institucional, id_menu_lateral)
    id_navegacion = crear_navegacion(url_institucional, nombre_pagina, id_pagina_institucional)

    institucionales = cargar_hijos(1225)

    ids_navs = Enum.map(
      institucionales,
      fn elemento ->
        busqueda_recursiva(elemento, url_institucional, nombre_pagina, nombre_pagina, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end
end
