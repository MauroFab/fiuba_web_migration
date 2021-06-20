defmodule Migracion_investigacion do

  import String
  import Utils

  def investigacion() do

    nodo = cargar_nodo("http:/investigacion") |> Enum.at(0)

    nombre_pagina = "Investigación"
    texto_pagina = ""
    url_investigacion = "/investigacion"
    nodo_type = nodo |> Enum.at(3)

    id_menu_lateral = crear_menu_lateral(url_investigacion)
    id_pagina_investigacion = crear_pagina(nombre_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_investigacion, nombre_pagina, id_pagina_investigacion)

    investigaciones = cargar_hijos(1161)

    ids_navs = Enum.map(
      investigaciones,
      fn elemento ->
        busqueda_recursiva(elemento, url_investigacion, id_menu_lateral)
      end
    )

    ids_navs_investigacion = if (contains?(nodo_type,"panel")) do
      ids_navs
    else
      []
    end

    actualizar_pagina(id_pagina_investigacion, texto_pagina, ids_navs_investigacion)
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end

end
