defmodule Migracion_investigacion do

  import Utils

  def investigacion() do

    nombre_pagina = "Investigación"
    texto_pagina = ""
    url_investigacion = "/investigacion"

    id_menu_lateral = crear_menu_lateral(url_investigacion)
    id_pagina_investigacion = crear_pagina(nombre_pagina, texto_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_investigacion, nombre_pagina, id_pagina_investigacion)

    investigaciones = cargar_hijos(1161)

    ids_navs = Enum.map(
      investigaciones,
      fn elemento ->
        busqueda_recursiva(elemento, url_investigacion, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end

end
