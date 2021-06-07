defmodule Migracion_maestria do

  import Utils

  def maestrias_posgrado() do

    maestrias = cargar_maestrias()

    Enum.map(
      maestrias,
      fn maestria ->
        nodos_asociados = cargar_nodos_asociados_maestrias(Enum.at(maestria, 1))
        nombre_maestria = Enum.at(maestria, 0)

        Enum.map(
          nodos_asociados,
          fn nodo ->

            texto_asociado = nodo |> Enum.at(1) |> cargar_texto_asociado |> Enum.at(0)

            nombre_nodo = texto_asociado |> Enum.at(0)
            texto_nodo = texto_asociado |> Enum.at(1)

            id_pagina = crear_pagina(nombre_nodo,texto_nodo)

            nombre_navegacion =
              if (String.contains?(nombre_nodo,nombre_maestria)) do ("Maestría - " <> nombre_maestria)
              else ( "Maestría - " <> nombre_maestria <> " - " <> nombre_nodo) end

            url_navegacion = "/ensenanza/posgrado/maestrias/" <> (
              if (String.contains?(nombre_nodo,nombre_maestria)) do (nombre_maestria |> url_format())
              else ((nombre_maestria |> url_format()) <> "/" <> (nombre_nodo |> url_format()) ) end
              )

            crear_navegacion(url_navegacion,nombre_navegacion,id_pagina)

          end
        )
      end
    )
  end



end
