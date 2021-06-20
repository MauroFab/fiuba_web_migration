defmodule Migracion_posgrado do

  import String
  import Utils

  def posgrado() do

    nodo = cargar_nodo("node/448") |> Enum.at(0)

    nombre_pagina = "Posgrado"
    texto_pagina = ""
    url_posgrado = "/posgrado"
    nodo_type = nodo |> Enum.at(3)

    id_menu_lateral = crear_menu_lateral(url_posgrado)
    id_pagina_posgrado = crear_pagina(nombre_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_posgrado, nombre_pagina, id_pagina_posgrado)

    posgrado_hijos = cargar_hijos(1155)

    ids_navs = Enum.map(
      posgrado_hijos,
      fn elemento ->
        busqueda_recursiva(elemento, url_posgrado, id_menu_lateral)
      end
    )

    ids_navs_posgrados = if (contains?(nodo_type,"panel")) do
      ids_navs
    else
      []
    end

    actualizar_pagina(id_pagina_posgrado, texto_pagina, ids_navs_posgrados)
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end

end
