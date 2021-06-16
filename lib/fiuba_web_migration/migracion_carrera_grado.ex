defmodule Migracion_carrera_grado do

  import Utils

  def carreras_grado() do

    nombre_pagina = "Carreras"
    jerarquia_pagina = nombre_pagina
    texto_pagina = ""
    url_carreras = "/ensenanza/grado/carreras"

    id_menu_lateral = crear_menu_lateral(url_carreras)
    id_pagina_carreras = crear_pagina(nombre_pagina, texto_pagina, jerarquia_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_carreras, nombre_pagina, id_pagina_carreras)

    carreras_info = cargar_hijos(1154)
    carreras = cargar_hijos(1018)

    ids_navs = Enum.map(
      carreras_info ++ carreras,
      fn elemento ->
        busqueda_recursiva(elemento, url_carreras, nombre_pagina, jerarquia_pagina, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end

end
