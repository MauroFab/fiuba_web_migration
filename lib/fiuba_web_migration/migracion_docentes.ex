defmodule Migracion_docentes do

  import Utils

  def docentes() do

    docentes = cargar_nodo("node/285") |> Enum.at(0)

    nombre_pagina = docentes |> Enum.at(0)
    texto_pagina = docentes |> Enum.at(1)
    url_docentes = "/docentes"

    id_menu_lateral = crear_menu_lateral(url_docentes)
    id_pagina_docentes = crear_pagina(nombre_pagina, texto_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_docentes, nombre_pagina, id_pagina_docentes)

    docentes_opts = cargar_hijos(906)

    ids_navs = Enum.map(
      docentes_opts,
      fn elemento ->
        busqueda_recursiva(elemento, url_docentes, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)

  end
end
