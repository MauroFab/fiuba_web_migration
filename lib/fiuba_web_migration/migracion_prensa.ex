defmodule Migracion_prensa do

  import Utils

  def prensa() do
    prensa = cargar_nodo_padre_standard(917) |> Enum.at(0)

    nid = prensa |> Enum.at(2)
    nodo = cargar_nodo(nid) |> Enum.at(0)

    nombre_pagina = nodo |> Enum.at(0)
    texto_prensa = nodo |> Enum.at(1)
    url_prensa = "/prensa"

    texto_con_links =
      texto_prensa |> String.replace("<a href=\"", "\n") |> String.replace(">(+)</a>", "\n\n")

    id_menu_lateral = crear_menu_lateral(url_prensa)
    id_pagina_prensa = crear_pagina(nombre_pagina, texto_con_links, nombre_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_prensa, nombre_pagina, id_pagina_prensa)

    prensa_anios = prensa |> Enum.at(0) |> cargar_hijos()

    ids_navs = Enum.map(
      prensa_anios,
      fn elemento ->
        busqueda_recursiva(elemento, url_prensa, nombre_pagina, nombre_pagina, id_menu_lateral)
      end
    )
    actualizar_menu_lateral( id_menu_lateral, [id_navegacion] ++ ids_navs)
  end
end
