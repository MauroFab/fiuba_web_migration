defmodule Migracion_maestria do
  import Utils

  def maestrias_posgrado() do
    maestrias = cargar_nodo_padre_no_standard(1157)

    Enum.map(
      maestrias,
      fn maestria ->
        nodos_asociados = cargar_nodos_asociados_maestrias(Enum.at(maestria, 0))
        nombre_maestria = Enum.at(maestria, 1)

        Enum.map(
          nodos_asociados,
          fn nodo ->
            texto_asociado = nodo |> Enum.at(1) |> cargar_texto_asociado |> Enum.at(0)

            nombre_nodo = texto_asociado |> Enum.at(0)
            texto_nodo = texto_asociado |> Enum.at(1)

            jerarquia_pagina =
              if String.contains?(nombre_nodo, nombre_maestria) do
                "Posgrado/Maestrias/" <> nombre_maestria
              else
                "Posgrado/Maestrias/" <> nombre_maestria <> "/" <> nombre_nodo
              end

            id_pagina = crear_pagina(nombre_nodo, texto_nodo, jerarquia_pagina)

            nombre_navegacion =
              if String.contains?(nombre_nodo, nombre_maestria) do
                "Posgrado - Maestrías - " <> nombre_maestria
              else
                "Posgrado - Maestrías - " <> nombre_maestria <> " - " <> nombre_nodo
              end

            url_navegacion =
              "/ensenanza/posgrado/maestrias/" <>
                if String.contains?(nombre_nodo, nombre_maestria) do
                  nombre_maestria |> url_format()
                else
                  (nombre_maestria |> url_format()) <> "/" <> (nombre_nodo |> url_format())
                end

            crear_navegacion(url_navegacion, nombre_navegacion, id_pagina)
          end
        )
      end
    )
  end
end
