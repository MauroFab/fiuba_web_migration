defmodule Migracion_institucional do

  import String
  import Utils

  def institucional() do

    # REQUIRE BORRAR UN REGISTRO EN MENU_LINKS: menu_links.link_path = 'node/1406'
    # TAMBIEN menu_link_path = 'departamento/32/novedades'
    nodo_institucional = cargar_nodo("node/514") |> Enum.at(0)

    nombre_pagina = nodo_institucional |> Enum.at(0)
    texto_pagina = nodo_institucional |> Enum.at(1)
    nodo_type = nodo_institucional |> Enum.at(3)
    url_institucional = "/institucional"

    id_menu_lateral = crear_menu_lateral(url_institucional)
    id_pagina_institucional = crear_pagina(nombre_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_institucional, nombre_pagina, id_pagina_institucional)

    institucionales = cargar_hijos(1225)

    ids_navs =
      Enum.map(
        institucionales,
        fn elemento ->
          busqueda_recursiva(elemento, url_institucional, id_menu_lateral)
        end
      )

    ids_navs_pag = if (contains?(nodo_type,"panel")) do
      ids_navs
    else
      []
    end

    actualizar_pagina(id_pagina_institucional, texto_pagina, ids_navs_pag)
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end

end
