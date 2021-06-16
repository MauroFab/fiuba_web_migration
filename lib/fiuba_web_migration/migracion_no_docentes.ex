defmodule Migracion_no_docentes do

  import Utils

  def no_docentes() do

    no_docentes = cargar_nodo_padre_standard(1604) |> Enum.at(0)

    nid = no_docentes |> Enum.at(2)
    nodo = cargar_nodo(nid) |> Enum.at(0)

    nombre_pagina = nodo |> Enum.at(0)
    texto_pagina = nodo |> Enum.at(1)
    url_no_docentes = "/no-docentes"
    jerarquia_padre = "No-docentes"

    id_menu_lateral = crear_menu_lateral(url_no_docentes)
    id_pagina_no_docentes = crear_pagina(nombre_pagina, texto_pagina, jerarquia_padre, id_menu_lateral)
    id_navegacion = crear_navegacion(url_no_docentes, nombre_pagina, id_pagina_no_docentes)

    no_docentes_opts = no_docentes |> Enum.at(0) |> cargar_hijos()

    ids_navs = Enum.map(
      no_docentes_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_no_docentes, nombre_pagina, jerarquia_padre, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end
end
