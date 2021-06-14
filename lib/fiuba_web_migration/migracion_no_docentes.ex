defmodule Migracion_no_docentes do
  import Utils

  # alias FiubaWebMigration.Repo

  # def cargar_no_docentes() do
  #   query_sql = "SELECT
  #       menu_links.mlid AS mlid,
  #       menu_links.link_title AS titulo,
  #       REPLACE(menu_links.link_path, 'node/','') AS nid
  #     FROM menu_links
  #     WHERE menu_links.mlid = 1604
  #     AND menu_links.router_path= 'node/%';"

  #   {:ok, respuesta} = Repo.query(query_sql)
  #   respuesta.rows
  # end

  def no_docentes() do
    no_docentes = cargar_nodo_padre_standard(1604) |> Enum.at(0)

    nid = no_docentes |> Enum.at(2)
    nodo = cargar_nodo(nid) |> Enum.at(0)

    nombre_pagina = nodo |> Enum.at(0)
    texto_pagina = nodo |> Enum.at(1)

    jerarquia_padre = "No-docentes"

    id_pagina_no_docentes = crear_pagina(nombre_pagina, texto_pagina, jerarquia_padre)

    url_no_docentes = "/no-docentes"
    crear_navegacion(url_no_docentes, nombre_pagina, id_pagina_no_docentes)

    no_docentes_opts = no_docentes |> Enum.at(0) |> cargar_hijos()

    Enum.map(
      no_docentes_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_no_docentes, nombre_pagina, jerarquia_padre)
      end
    )
  end
end
