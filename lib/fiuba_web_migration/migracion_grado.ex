defmodule Migracion_grado do

  import String
  import Utils

  def grado() do

    # REQUIRE BORRAR EL REGISTRO EN MENU_LINKS: menu_links.link_title = 'Videoteca'
    # REQUIRE BORRAR LOS REGISTROS EN MENU_LINKS: menu_links.link_title = 'Videos'

    nodo = cargar_nodo("node/447") |> Enum.at(0)

    nombre_pagina = "Grado"
    texto_pagina = ""
    url_grado = "/grado"
    nodo_type = nodo |> Enum.at(3)

    id_menu_lateral = crear_menu_lateral(url_grado)
    id_pagina_grado = crear_pagina(nombre_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_grado, nombre_pagina, id_pagina_grado)

    grado = cargar_hijos(1154)

    ids_navs = Enum.map(
      grado,
      fn elemento ->
        busqueda_recursiva(elemento, url_grado, id_menu_lateral)
      end
    )

    ids_navs_grados = if (contains?(nodo_type,"panel")) do
      ids_navs
    else
      []
    end

    actualizar_pagina(id_pagina_grado, texto_pagina, ids_navs_grados)
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end

end
