defmodule Migracion_bienestar do

  import String
  import Utils

  def bienestar() do

    nodo = cargar_nodo("node/453") |> Enum.at(0)

    texto_pagina = ""
    nombre_pagina = "Bienestar"
    url_bienestar = "/bienestar"
    nodo_type = nodo |> Enum.at(3)

    id_menu_lateral = crear_menu_lateral(url_bienestar)
    id_pagina_bienestar = crear_pagina(nombre_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_bienestar, nombre_pagina, id_pagina_bienestar)

    bienestares = cargar_hijos(1162)

    ids_navs = Enum.map(
      bienestares,
      fn elemento ->
        busqueda_recursiva(elemento, url_bienestar, id_menu_lateral)
      end
    )

    ids_navs_bienestares = if (contains?(nodo_type,"panel")) do
      ids_navs
    else
      []
    end

    actualizar_pagina(id_pagina_bienestar, texto_pagina, ids_navs_bienestares)
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end
end
