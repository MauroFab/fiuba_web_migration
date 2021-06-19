defmodule Migracion_grado do

  import Utils

  def grado() do

    # REQUIRE BORRAR EL REGISTRO EN MENU_LINKS: menu_links.link_title = 'Videoteca'
    # REQUIRE BORRAR LOS REGISTROS EN MENU_LINKS: menu_links.link_title = 'Videos'

    nombre_pagina = "Grado"
    texto_pagina = ""
    url_grado = "/grado"

    id_menu_lateral = crear_menu_lateral(url_grado)
    id_pagina_grado = crear_pagina(nombre_pagina, texto_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_grado, nombre_pagina, id_pagina_grado)

    grado = cargar_hijos(1154)

    ids_navs = Enum.map(
      grado,
      fn elemento ->
        busqueda_recursiva(elemento, url_grado, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end

end
