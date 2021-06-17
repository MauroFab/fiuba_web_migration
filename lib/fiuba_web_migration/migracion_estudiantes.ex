defmodule Migracion_estudiantes do

  import Utils

  def estudiantes() do

    estudiantes = cargar_nodo(745) |> Enum.at(0)

    nombre_pagina = estudiantes |> Enum.at(0)
    texto_pagina = estudiantes |> Enum.at(1)
    url_estudiantes = "/estudiantes"

    id_menu_lateral = crear_menu_lateral(url_estudiantes)
    id_pagina_estudiantes = crear_pagina(nombre_pagina, texto_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_estudiantes, nombre_pagina, id_pagina_estudiantes)

    estudiantes_opts = cargar_hijos(1600)

    ids_navs = Enum.map(
      estudiantes_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_estudiantes, nombre_pagina, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)

  end
end
