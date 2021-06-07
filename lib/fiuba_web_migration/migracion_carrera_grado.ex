defmodule Migracion_carrera_grado do

  import Utils

  alias FiubaWebMigration.Repo
  import Ecto.Query
  import JSON
  import String

  def cargar_carreras_grado do

    query_sql = "SELECT
        menu_links.link_title AS titulo,
        menu_links.mlid AS mlid
      FROM menu_links
      WHERE menu_links.plid = '1018'
      ORDER BY menu_links.link_title DESC"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end


  def carreras_grado() do

    carreras = cargar_carreras_grado()

    Enum.map(
      carreras,
      fn carrera ->
        nodos_asociados = cargar_nodos_asociados(Enum.at(carrera, 1))
        nombre_carrera = Enum.at(carrera, 0)

        componentes_pagina =
          Enum.map(
            nodos_asociados,
            fn nodo ->
              texto_asociado = Enum.at(cargar_texto_asociado(Enum.at(nodo, 1)), 0)

              nombre_nodo = texto_asociado |> Enum.at(0)
              texto_nodo = texto_asociado |> Enum.at(1)

              #Se crea la página
              id_pagina = crear_pagina(nombre_nodo, texto_nodo)

              #Se crea la navegación
              nombre_navegacion =
                if (String.contains?(nombre_nodo,nombre_carrera)) do ("Carrera - " <> nombre_carrera)
                else ("Carrera - " <> nombre_carrera <> " - " <> nombre_nodo) end

              url_navegacion = "/ensenanza/grado/carreras/" <> (
                if (String.contains?(nombre_nodo,nombre_carrera)) do (nombre_carrera |> url_format())
                else ((nombre_carrera |> url_format()) <> "/" <> (nombre_nodo |> url_format()) ) end
                )

              crear_navegacion(url_navegacion, nombre_navegacion, id_pagina)

            end
          )
      end
    )
  end

end
