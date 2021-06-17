defmodule Migracion_extranjeros do

  import Utils

  def extranjeros() do

    extranjeros = cargar_nodo(747)|> Enum.at(0)

    nombre_pagina = extranjeros |> Enum.at(0)
    texto_pagina = extranjeros |> Enum.at(1)
    url_extranjeros = "/extranjeros"

    id_menu_lateral = crear_menu_lateral(url_extranjeros)
    id_pagina_extranjeros = crear_pagina(nombre_pagina, texto_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_extranjeros, nombre_pagina, id_pagina_extranjeros)

    extranjeros_opts = cargar_hijos(1602)

    ids_navs = Enum.map(
      extranjeros_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_extranjeros, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end
end
