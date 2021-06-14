defmodule Migracion_prensa do
  import Utils

  # alias FiubaWebMigration.Repo

  # def cargar_prensa() do

  #   query_sql = "SELECT
  #       menu_links.mlid AS mlid,
  #       menu_links.link_title AS titulo,
  #       REPLACE(menu_links.link_path, 'node/','') AS nid
  #     FROM menu_links
  #     WHERE menu_links.mlid = 917;"

  #   {:ok, respuesta} = Repo.query(query_sql)
  #   respuesta.rows

  # end

  # def prensa_recursivo(elemento, url_nav_padre, nombre_nav_padre) do

  #   nid = elemento |> Enum.at(2)
  #   nodo = cargar_nodo(nid) |> Enum.at(0)

  #   titulo = nodo |> Enum.at(0)
  #   texto_prensa = nodo |> Enum.at(1)
  #   texto_con_links = texto_prensa |> String.replace( "<a href=", "\n") |> String.replace(">(+)</a>", "\n\n")

  #   id_pagina = crear_pagina(titulo, texto_con_links)

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
  #         prensa_recursivo(hijo,url_nav,nombre_nav)
  #       end
  #     )
  #   end
  # end

  def prensa() do
    prensa = cargar_nodo_padre_standard(917) |> Enum.at(0)

    nid = prensa |> Enum.at(2)
    nodo = cargar_nodo(nid) |> Enum.at(0)

    nombre_pagina = nodo |> Enum.at(0)
    texto_prensa = nodo |> Enum.at(1)

    texto_con_links =
      texto_prensa |> String.replace("<a href=\"", "\n") |> String.replace(">(+)</a>", "\n\n")

    id_pagina_prensa = crear_pagina(nombre_pagina, texto_con_links, nombre_pagina)

    url_prensa = "/prensa"
    crear_navegacion(url_prensa, nombre_pagina, id_pagina_prensa)

    prensa_anios = prensa |> Enum.at(0) |> cargar_hijos()

    Enum.map(
      prensa_anios,
      fn elemento ->
        busqueda_recursiva(elemento, url_prensa, nombre_pagina, nombre_pagina)
      end
    )
  end
end
