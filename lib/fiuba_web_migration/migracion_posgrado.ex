defmodule Migracion_posgrado do

  import Utils

  def posgrado() do

    nombre_pagina = "Posgrado"
    texto_pagina = ""
    url_posgrado = "/posgrado"

    id_menu_lateral = crear_menu_lateral(url_posgrado)
    id_pagina_posgrado = crear_pagina(nombre_pagina, texto_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_posgrado, nombre_pagina, id_pagina_posgrado)

    posgrado_hijos = cargar_hijos(1155)

    ids_navs = Enum.map(
      posgrado_hijos,
      fn elemento ->
        busqueda_recursiva(elemento, url_posgrado, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end

end
