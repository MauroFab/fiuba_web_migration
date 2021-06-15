defmodule Migracion_biblioteca do
  import Utils

  # alias FiubaWebMigration.Repo

  # def cargar_biblioteca() do
  #   query_sql = "SELECT
  #       menu_links.mlid AS mlid,
  #       menu_links.link_title AS titulo,
  #       REPLACE(menu_links.link_path, 'node/','') AS nid
  #     FROM menu_links
  #     WHERE menu_links.mlid = 923
  #     AND menu_links.router_path= 'node/%';"

  #   {:ok, respuesta} = Repo.query(query_sql)
  #   respuesta.rows
  # end

  # def biblioteca_recursivo(elemento, url_nav_padre, nombre_nav_padre) do
  #   nid = elemento |> Enum.at(2)
  #   nodo = cargar_nodo(nid) |> Enum.at(0)

  #   titulo = nodo |> Enum.at(0)
  #   texto = nodo |> Enum.at(1)

  #   id_pagina = crear_pagina(titulo, texto)

  #   nombre_nav = nombre_nav_padre <> " - " <> titulo
  #   url_nav = url_nav_padre <> "/" <> (titulo |> url_format())

  #   crear_navegacion(url_nav, nombre_nav, id_pagina)

  #   # 1 = Tiene hijos, 0 = No tiene hijos
  #   has_children = elemento |> Enum.at(3)

  #   if has_children == 1 do
  #     hijos = elemento |> Enum.at(0) |> cargar_hijos

  #     Enum.map(
  #       hijos,
  #       fn hijo ->
  #         biblioteca_recursivo(hijo, url_nav, nombre_nav)
  #       end
  #     )
  #   end
  # end

  def biblioteca() do
    biblioteca = cargar_nodo_padre_standard(923) |> Enum.at(0)

    nid = biblioteca |> Enum.at(2)
    nodo = cargar_nodo(nid) |> Enum.at(0)

    nombre_pagina = nodo |> Enum.at(0)
    texto_pagina = nodo |> Enum.at(1)
    url_biblioteca = "/biblioteca"

    id_menu_lateral = crear_menu_lateral("biblioteca")
    id_pagina_biblioteca = crear_pagina(nombre_pagina, texto_pagina, nombre_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_biblioteca, nombre_pagina, id_pagina_biblioteca)

    biblioteca_opts = biblioteca |> Enum.at(0) |> cargar_hijos()

    ids_navs = Enum.map(
      biblioteca_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_biblioteca, nombre_pagina, nombre_pagina, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end
end
