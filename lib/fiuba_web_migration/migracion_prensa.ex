defmodule Migracion_prensa do

  import String
  import Utils

  def prensa() do

    nodo = cargar_nodo("node/877") |> Enum.at(0)

    nombre_pagina = nodo |> Enum.at(0)
    texto_prensa = nodo |> Enum.at(1)
    url_prensa = "/prensa"
    nodo_type = nodo |> Enum.at(3)

    # texto_con_links =
    #   texto_prensa |> String.replace("<a href=\"", "\n") |> String.replace(">(+)</a>", "\n\n")

    id_menu_lateral = crear_menu_lateral(url_prensa)
    id_pagina_prensa = crear_pagina(nombre_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_prensa, nombre_pagina, id_pagina_prensa)

    prensa_anios = cargar_hijos(917)

    ids_navs = Enum.map(
      prensa_anios,
      fn elemento ->
        busqueda_recursiva(elemento, url_prensa, id_menu_lateral)
      end
    )

    ids_navs_prensa = if (contains?(nodo_type,"panel")) do
      ids_navs
    else
      []
    end

    actualizar_pagina(id_pagina_prensa, texto_prensa, ids_navs_prensa)
    actualizar_menu_lateral( id_menu_lateral, [id_navegacion] ++ ids_navs)
  end

end
