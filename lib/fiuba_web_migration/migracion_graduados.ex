defmodule Migracion_graduados do

  import Utils

  def graduados() do

    graduados = cargar_nodo("node/2602") |> Enum.at(0)

    nombre_pagina = graduados |> Enum.at(0)
    texto_pagina = graduados |> Enum.at(1)
    url_graduados = "/graduados"

    id_menu_lateral = crear_menu_lateral(url_graduados)
    id_pagina_graduados = crear_pagina(nombre_pagina, texto_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_graduados, nombre_pagina, id_pagina_graduados)

    graduados_opts = cargar_hijos(2716)

    ids_navs = Enum.map(
      graduados_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_graduados, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end
end
