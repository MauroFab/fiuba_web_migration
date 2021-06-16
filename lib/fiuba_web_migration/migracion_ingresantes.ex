defmodule Migracion_ingresantes do

  import Utils

  def ingresantes() do

    ingresantes = cargar_nodo(744) |> Enum.at(0)

    nombre_pagina = ingresantes |> Enum.at(0)
    texto_pagina = ingresantes |> Enum.at(1)
    jerarquia = nombre_pagina
    url_ingresantes = "/ingresantes"

    id_menu_lateral = crear_menu_lateral(url_ingresantes)
    id_pagina_ingresantes = crear_pagina(nombre_pagina, texto_pagina, jerarquia, id_menu_lateral)
    id_navegacion = crear_navegacion(url_ingresantes, nombre_pagina, id_pagina_ingresantes)

    ingresantes_opts = cargar_hijos(1599)

    ids_navs = Enum.map(
      ingresantes_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_ingresantes, nombre_pagina, jerarquia, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end
end
