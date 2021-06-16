defmodule Migracion_graduados do

  import Utils

  def graduados() do

    graduados = cargar_nodo_padre_standard(2716) |> Enum.at(0)

    nid = graduados |> Enum.at(2)
    nodo = cargar_nodo(nid) |> Enum.at(0)

    nombre_pagina = nodo |> Enum.at(0)
    texto_pagina = nodo |> Enum.at(1)
    url_graduados = "/graduados"

    id_menu_lateral = crear_menu_lateral(url_graduados)
    id_pagina_graduados = crear_pagina(nombre_pagina, texto_pagina, nombre_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_graduados, nombre_pagina, id_pagina_graduados)

    graduados_opts = graduados |> Enum.at(0) |> cargar_hijos()

    ids_navs = Enum.map(
      graduados_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_graduados, nombre_pagina, nombre_pagina, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end
end
