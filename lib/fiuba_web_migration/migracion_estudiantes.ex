defmodule Migracion_estudiantes do

  import Utils

  def estudiantes() do

    estudiantes = cargar_nodo_padre_standard(1600) |> Enum.at(0)

    nid = estudiantes |> Enum.at(2)
    nodo = cargar_nodo(nid) |> Enum.at(0)

    nombre_pagina = nodo |> Enum.at(0)
    texto_pagina = nodo |> Enum.at(1)
    url_estudiantes = "/estudiantes"

    id_menu_lateral = crear_menu_lateral(url_estudiantes)
    id_pagina_estudiantes = crear_pagina(nombre_pagina, texto_pagina, nombre_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_estudiantes, nombre_pagina, id_pagina_estudiantes)

    estudiantes_opts = estudiantes |> Enum.at(0) |> cargar_hijos()

    ids_navs = Enum.map(
      estudiantes_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_estudiantes, nombre_pagina, nombre_pagina, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)

  end
end
