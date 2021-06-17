defmodule Migracion_anuales_bianuales do

  import Utils

  def anuales_bianuales() do

    nombre_pagina = "Cursos anuales y bianuales"
    jerarquia_pagina = nombre_pagina
    texto_pagina = ""
    url_bianuales = "/posgrado/cursos-anuales-y-bianuales"

    id_menu_lateral = crear_menu_lateral(url_bianuales)
    id_pagina_bianuales = crear_pagina(nombre_pagina, texto_pagina, jerarquia_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_bianuales, nombre_pagina, id_pagina_bianuales)

    anuales_bianuales = cargar_hijos(1159)

    ids_navs = Enum.map(
      anuales_bianuales,
      fn elemento ->
        busqueda_recursiva(elemento, url_bianuales, nombre_pagina, nombre_pagina, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end

end
