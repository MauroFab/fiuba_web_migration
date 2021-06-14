defmodule Migracion_bienestar do
  import Utils

  alias FiubaWebMigration.Repo

  # def cargar_bienestar() do
  #   query_sql = "SELECT
  #       menu_links.mlid AS mlid,
  #       menu_links.link_title AS titulo
  #     FROM menu_links
  #     WHERE menu_links.mlid = 1162;"

  #   {:ok, respuesta} = Repo.query(query_sql)
  #   respuesta.rows
  # end

  # def bienestar_recursivo(elemento, url_nav_padre, nombre_nav_padre) do
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
  #         bienestar_recursivo(hijo, url_nav, nombre_nav)
  #       end
  #     )
  #   end
  # end

  def bienestar() do
    bienestar = cargar_nodo_padre_standard(1162) |> Enum.at(0)

    texto_pagina = ""
    nombre_pagina = "Bienestar"

    id_pagina_bienestar = crear_pagina(nombre_pagina, texto_pagina, nombre_pagina)

    url_bienestar = "/bienestar"
    crear_navegacion(url_bienestar, nombre_pagina, id_pagina_bienestar)

    bienestares = bienestar |> Enum.at(0) |> cargar_hijos()

    Enum.map(
      bienestares,
      fn elemento ->
        busqueda_recursiva(elemento, url_bienestar, nombre_pagina, nombre_pagina)
      end
    )
  end
end
