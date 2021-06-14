defmodule Migracion_investigacion do
  import Utils

  # alias FiubaWebMigration.Repo
  # import Ecto.Query
  # import JSON
  # import String

  # def cargar_investigacion() do
  #   query_sql = "SELECT
  #       menu_links.mlid AS mlid,
  #       menu_links.link_title AS titulo
  #     FROM menu_links
  #     WHERE menu_links.mlid = 1161;"

  #   {:ok, respuesta} = Repo.query(query_sql)
  #   respuesta.rows
  # end

  # def investigacion_recursivo(elemento, url_nav_padre, nombre_nav_padre) do
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
  #         investigacion_recursivo(hijo, url_nav, nombre_nav)
  #       end
  #     )
  #   end
  # end

  def investigacion() do
    investigacion = cargar_nodo_padre_no_standard(1161) |> Enum.at(0)

    texto_pagina = ""
    nombre_pagina = "Investigación"

    id_pagina_investigacion = crear_pagina(nombre_pagina, texto_pagina, nombre_pagina)

    url_investigacion = "/investigacion"
    crear_navegacion(url_investigacion, nombre_pagina, id_pagina_investigacion)

    investigaciones = investigacion |> Enum.at(0) |> cargar_hijos()

    Enum.map(
      investigaciones,
      fn elemento ->
        busqueda_recursiva(elemento, url_investigacion, nombre_pagina, nombre_pagina)
      end
    )
  end
end
