defmodule Migracion_carrera_especializacion do
  import Utils
  # alias FiubaWebMigration.Repo
  # import String

  # def cargar_carreras_especializacion do
  #   query_sql = "SELECT
  #       menu_links.mlid AS mlid,
  #       menu_links.link_title AS titulo
  #     FROM menu_links
  #     WHERE menu_links.plid = '1158'
  #     ORDER BY menu_links.link_title ASC"

  #   {:ok, respuesta} = Repo.query(query_sql)
  #   respuesta.rows
  # end

  def cargar_nodos_asociados_carreras_especializadas(mlid) do
    query_sql =
      "SELECT
        menu_links.link_title AS titulo_nodo_asociado,
        REPLACE(menu_links.link_path, 'node/','') AS nid
      FROM menu_links
      WHERE menu_links.plid = " <>
        to_string(mlid) <> " OR menu_links.mlid = " <> to_string(mlid) <> ";"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end

  def carreras_especializaciones() do
    Enum.map(
      cargar_nodo_padre_standard(1158),
      fn especializacion ->
        nombre_carrera = Enum.at(especializacion, 1)

        Enum.map(
          cargar_nodos_asociados_carreras_especializadas(Enum.at(especializacion, 0)),
          fn nodo ->
            texto_asociado = Enum.at(cargar_texto_asociado(Enum.at(nodo, 1)), 0)

            nombre_nodo = texto_asociado |> Enum.at(0)
            texto_nodo = texto_asociado |> Enum.at(1)

            # Se crea la página
            id_pagina = crear_pagina(nombre_nodo, texto_nodo, nombre_nodo)

            # Se crea la navegación
            nombre_navegacion =
              if String.contains?(nombre_nodo, nombre_carrera) do
                "Carrera de Especializacion: " <> nombre_carrera
              else
                "Carrera de Especializacion: " <> nombre_carrera <> " - " <> nombre_nodo
              end

            url_navegacion =
              "/ensenanza/posgrado/carreras-de-especializacion/" <>
                if String.contains?(nombre_nodo, nombre_carrera) do
                  nombre_carrera |> url_format()
                else
                  (nombre_carrera |> url_format()) <> "/" <> (nombre_nodo |> url_format())
                end

            crear_navegacion(url_navegacion, nombre_navegacion, id_pagina)
          end
        )
      end
    )
  end
end
