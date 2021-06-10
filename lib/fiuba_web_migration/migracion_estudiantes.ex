defmodule Migracion_estudiantes do
  import Utils

  alias FiubaWebMigration.Repo

  def cargar_estudiantes() do
    query_sql = "SELECT
        menu_links.mlid AS mlid,
        menu_links.link_title AS titulo,
        REPLACE(menu_links.link_path, 'node/','') AS nid
      FROM menu_links
      WHERE menu_links.mlid = 1600
      AND menu_links.router_path= 'node/%';"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end

  def estudiantes() do
    estudiantes = cargar_estudiantes() |> Enum.at(0)

    nid = estudiantes |> Enum.at(2)
    nodo = cargar_nodo(nid) |> Enum.at(0)

    nombre_pagina = nodo |> Enum.at(0)
    texto_pagina = nodo |> Enum.at(1)

    jerarquia_padre = "Estudiantes"

    id_pagina_estudiantes = crear_pagina(nombre_pagina, texto_pagina, jerarquia_padre)

    url_estudiantes = "/estudiantes"
    crear_navegacion(url_estudiantes, nombre_pagina, id_pagina_estudiantes)

    estudiantes_opts = estudiantes |> Enum.at(0) |> cargar_hijos()

    Enum.map(
      estudiantes_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_estudiantes, nombre_pagina, jerarquia_padre)
      end
    )
  end
end
