defmodule Migracion_no_docentes do

  import String
  import Utils

  def no_docentes() do

    no_docentes = cargar_nodo("node/749") |> Enum.at(0)

    nombre_pagina = no_docentes |> Enum.at(0)
    texto_pagina = no_docentes |> Enum.at(1)
    url_no_docentes = "/no-docentes"
    nodo_type = no_docentes |> Enum.at(3)

    id_menu_lateral = crear_menu_lateral(url_no_docentes)
    id_pagina_no_docentes = crear_pagina(nombre_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_no_docentes, nombre_pagina, id_pagina_no_docentes)

    no_docentes_opts = cargar_hijos(1604)

    ids_navs = Enum.map(
      no_docentes_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_no_docentes, id_menu_lateral)
      end
    )

    ids_navs_no_docentes = if (contains?(nodo_type,"panel")) do
      ids_navs
    else
      []
    end

    actualizar_pagina(id_pagina_no_docentes, texto_pagina, ids_navs_no_docentes)
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end
end
