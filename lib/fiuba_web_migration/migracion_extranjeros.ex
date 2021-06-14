defmodule Migracion_extranjeros do
  import Utils

  # alias FiubaWebMigration.Repo

  # def cargar_extranjeros() do
  #   query_sql = "SELECT
  #       menu_links.mlid AS mlid,
  #       menu_links.link_title AS titulo,
  #       REPLACE(menu_links.link_path, 'node/','') AS nid
  #     FROM menu_links
  #     WHERE menu_links.mlid = 1602
  #     AND menu_links.router_path= 'node/%';"

  #   {:ok, respuesta} = Repo.query(query_sql)
  #   respuesta.rows
  # end

  def extranjeros() do
    extranjeros = cargar_nodo_padre_standard(1602) |> Enum.at(0)

    nid = extranjeros |> Enum.at(2)
    nodo = cargar_nodo(nid) |> Enum.at(0)

    nombre_pagina = nodo |> Enum.at(0)
    texto_pagina = nodo |> Enum.at(1)

    id_pagina_extranjeros = crear_pagina(nombre_pagina, texto_pagina, nombre_pagina)

    url_extranjeros = "/extranjeros"
    crear_navegacion(url_extranjeros, nombre_pagina, id_pagina_extranjeros)

    extranjeros_opts = extranjeros |> Enum.at(0) |> cargar_hijos()

    Enum.map(
      extranjeros_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_extranjeros, nombre_pagina, nombre_pagina)
      end
    )
  end
end
