defmodule Migracion_institucional do

  import Utils

  def institucional() do

    # REQUIRE BORRAR UN REGISTRO EN MENU_LINKS: menu_links.link_path = 'node/1406'

    texto_pagina = ""
    nombre_pagina = "Institucional"
    jerarquia_institucional = nombre_pagina
    url_institucional = "/institucional"

    id_menu_lateral = crear_menu_lateral(url_institucional)
    id_pagina_institucional = crear_pagina(nombre_pagina, texto_pagina, jerarquia_institucional, id_menu_lateral)
    id_navegacion = crear_navegacion(url_institucional, nombre_pagina, id_pagina_institucional)

    institucionales = cargar_hijos(1225)

    ids_navs = Enum.map(
      institucionales,
      fn elemento ->
        busqueda_recursiva(elemento, url_institucional, nombre_pagina, nombre_pagina, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end
end
