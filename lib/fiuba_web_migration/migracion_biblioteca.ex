defmodule Migracion_biblioteca do

  import String
  import Utils

  def biblioteca() do

    biblioteca = cargar_nodo("node/1282") |> Enum.at(0)

    nombre_pagina = biblioteca |> Enum.at(0)
    texto_pagina = ""
    url_biblioteca = "/biblioteca"
    nodo_type = biblioteca |> Enum.at(3)

    id_menu_lateral = crear_menu_lateral(url_biblioteca)
    id_pagina_biblioteca = crear_pagina(nombre_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_biblioteca, nombre_pagina, id_pagina_biblioteca)

    biblioteca_opts = cargar_hijos(923)

    ids_navs = Enum.map(
      biblioteca_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_biblioteca, id_menu_lateral)
      end
    )

    ids_navs_bibliotecas = if (contains?(nodo_type,"panel")) do
      ids_navs
    else
      []
    end

    actualizar_pagina(id_pagina_biblioteca, texto_pagina, ids_navs_bibliotecas)
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end
end
