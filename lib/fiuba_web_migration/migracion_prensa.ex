defmodule Migracion_prensa do

  import Utils

  def prensa() do

    prensa = cargar_nodo(877) |> Enum.at(0)

    nombre_pagina = prensa |> Enum.at(0)
    texto_prensa = prensa |> Enum.at(1)
    url_prensa = "/prensa"

    # texto_con_links =
    #   texto_prensa |> String.replace("<a href=\"", "\n") |> String.replace(">(+)</a>", "\n\n")

    id_menu_lateral = crear_menu_lateral(url_prensa)
    id_pagina_prensa = crear_pagina(nombre_pagina, texto_prensa, nombre_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_prensa, nombre_pagina, id_pagina_prensa)

    prensa_anios = cargar_hijos(917)

    ids_navs = Enum.map(
      prensa_anios,
      fn elemento ->
        busqueda_recursiva(elemento, url_prensa, nombre_pagina, nombre_pagina, id_menu_lateral)
      end
    )
    actualizar_menu_lateral( id_menu_lateral, [id_navegacion] ++ ids_navs)
  end

end
