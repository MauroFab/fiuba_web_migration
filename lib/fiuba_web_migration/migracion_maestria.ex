defmodule Migracion_maestria do

  import Utils

  def maestrias_posgrado() do

    nombre_pagina = "Maestrías"
    texto_pagina = ""
    url_carreras_esp = "/posgrado/maestrias"

    id_menu_lateral = crear_menu_lateral(url_carreras_esp)
    id_pagina_carreras_esp = crear_pagina(nombre_pagina, texto_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_carreras_esp, nombre_pagina, id_pagina_carreras_esp)

    carreras_esp = cargar_hijos(1157)

    ids_navs = Enum.map(
      carreras_esp,
      fn elemento ->
        busqueda_recursiva(elemento, url_carreras_esp, nombre_pagina, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end

end
