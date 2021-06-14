defmodule Migracion_carrera_grado do
  import Utils

  import String

  def info_grado() do
    info_carreras = cargar_nodo_padre_standard(1154) |> Enum.at(0)

    nid = info_carreras |> Enum.at(2)
    nodo = cargar_nodo(nid) |> Enum.at(0)

    nombre_pagina = nodo |> Enum.at(0)
    texto_pagina = nodo |> Enum.at(1)

    jerarquia_padre = "Grado"

    id_menu_lateral = crear_menu_lateral("Grado")

    id_pagina_info_carreras = crear_pagina(nombre_pagina, texto_pagina, jerarquia_padre, id_menu_lateral)

    url_info_carreras = "/grado"
    crear_navegacion(url_info_carreras, nombre_pagina, id_pagina_info_carreras)

    info_carreras_opts = info_carreras |> Enum.at(0) |> cargar_hijos()

    ids_navegaciones = Enum.map(
      info_carreras_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_info_carreras, nombre_pagina, jerarquia_padre)
      end
    )
    actualizar_menu_lateral(id_menu_lateral,ids_navegaciones)
  end

  def carreras() do
    carreras = cargar_nodo_padre_no_standard(1018)

    Enum.map(
      carreras,
      fn carrera ->
        nodos_asociados = cargar_nodos_asociados(Enum.at(carrera, 0))
        nombre_carrera = Enum.at(carrera, 1)

        id_menu_lateral = crear_menu_lateral("Grado - Carreras - " <> nombre_carrera)

        ids_navegacion =
          Enum.map(
            nodos_asociados,
            fn nodo ->
              texto_asociado = Enum.at(cargar_texto_asociado(Enum.at(nodo, 1)), 0)
              nombre_nodo = texto_asociado |> Enum.at(0)
              texto_nodo = texto_asociado |> Enum.at(1)

              jerarquia_pagina =
                if String.contains?(nombre_nodo, nombre_carrera) do
                  "Grado/Carreras/" <> nombre_carrera
                else
                  "Grado/Carreras/" <> nombre_carrera <> "/" <> nombre_nodo
                end

              # Se crea la página
              id_pagina = crear_pagina(nombre_nodo, texto_nodo, jerarquia_pagina, id_menu_lateral)
              # Se crea la navegación
              nombre_navegacion =
                if String.contains?(nombre_nodo, nombre_carrera) do
                  "Grado - Carreras - " <> nombre_carrera
                else
                  "Grado - Carreras - " <> nombre_carrera <> " - " <> nombre_nodo
                end

              url_navegacion =
                "/ensenanza/grado/carreras/" <>
                  if String.contains?(nombre_nodo, nombre_carrera) do
                    nombre_carrera |> url_format()
                  else
                    (nombre_carrera |> url_format()) <> "/" <> (nombre_nodo |> url_format())
                  end

              crear_navegacion(url_navegacion, nombre_navegacion, id_pagina)
            end
          )
          actualizar_menu_lateral(id_menu_lateral,ids_navegacion)
      end
    )
  end

  def carreras_grado() do
    info_grado()
    carreras()
  end
end
