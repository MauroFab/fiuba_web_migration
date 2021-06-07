defmodule Migracion_anuales_bianuales do

  import Utils

  def anuales_bianuales do

    anuales = cargar_anuales_bianuales()

    Enum.map(
      anuales,
      fn anual ->
        nodos_asociados = anual |> Enum.at(1) |> cargar_nodos_asociados_maestrias()
        nombre_anual =anual |> Enum.at(0)

        Enum.map(
          nodos_asociados,
          fn nodo ->

            texto_asociado = nodo |> Enum.at(1) |> cargar_texto_asociado |> Enum.at(0)

            nombre_nodo = texto_asociado |> Enum.at(0)
            texto_nodo = texto_asociado |> Enum.at(1)

            id_pagina = crear_pagina(nombre_nodo,texto_nodo)

            nombre_navegacion =
              if (String.contains?(nombre_nodo,nombre_anual)) do "Anuales/Bianuales: " <> nombre_anual
              else ( "Anuales/Bianuales: " <> nombre_anual <> " - " <> nombre_nodo) end

            url_navegacion = "/ensenanza/posgrado/anuales-bianuales/" <> (
              if (String.contains?(nombre_nodo,nombre_anual)) do (nombre_anual |> url_format())
              else ((nombre_anual |> url_format()) <> "/" <> (nombre_nodo |> url_format()) ) end
              )

            crear_navegacion(url_navegacion,nombre_navegacion,id_pagina)


          end
        )
      end
    )
  end
end
