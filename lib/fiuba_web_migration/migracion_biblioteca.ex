defmodule Migracion_biblioteca do

  import Utils

  def biblioteca() do
    biblioteca = cargar_nodo_padre_standard(923) |> Enum.at(0)

    nid = biblioteca |> Enum.at(2)
    nodo = cargar_nodo(nid) |> Enum.at(0)

    nombre_pagina = nodo |> Enum.at(0)
    texto_pagina = nodo |> Enum.at(1)
    url_biblioteca = "/biblioteca"

    id_menu_lateral = crear_menu_lateral("biblioteca")
    id_pagina_biblioteca = crear_pagina(nombre_pagina, texto_pagina, nombre_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_biblioteca, nombre_pagina, id_pagina_biblioteca)

    biblioteca_opts = biblioteca |> Enum.at(0) |> cargar_hijos()

    ids_navs = Enum.map(
      biblioteca_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_biblioteca, nombre_pagina, nombre_pagina, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end
end
