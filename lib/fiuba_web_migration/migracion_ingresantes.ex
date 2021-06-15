defmodule Migracion_ingresantes do

  import Utils

  def ingresantes() do

    ingresantes = cargar_nodo_padre_standard(1599) |> Enum.at(0)

    nid = ingresantes |> Enum.at(2)
    nodo = cargar_nodo(nid) |> Enum.at(0)

    nombre_pagina = nodo |> Enum.at(0)
    texto_pagina = nodo |> Enum.at(1)
    url_ingresantes = "/ingresantes"

    id_menu_lateral = crear_menu_lateral(url_ingresantes)
    id_pagina_ingresantes = crear_pagina(nombre_pagina, texto_pagina, nombre_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_ingresantes, nombre_pagina, id_pagina_ingresantes)

    ingresantes_opts = ingresantes |> Enum.at(0) |> cargar_hijos()

    ids_navs = Enum.map(
      ingresantes_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_ingresantes, nombre_pagina, nombre_pagina, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end
end
