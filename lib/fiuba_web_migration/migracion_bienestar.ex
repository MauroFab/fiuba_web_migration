defmodule Migracion_bienestar do

  import Utils

  def bienestar() do

    bienestar = cargar_nodo_padre_standard(1162) |> Enum.at(0)

    texto_pagina = ""
    nombre_pagina = "Bienestar"
    url_bienestar = "/bienestar"

    id_menu_lateral = crear_menu_lateral(url_bienestar)
    id_pagina_bienestar = crear_pagina(nombre_pagina, texto_pagina, nombre_pagina, id_menu_lateral)
    id_navegacion = crear_navegacion(url_bienestar, nombre_pagina, id_pagina_bienestar)

    bienestares = bienestar |> Enum.at(0) |> cargar_hijos()

    ids_navs = Enum.map(
      bienestares,
      fn elemento ->
        busqueda_recursiva(elemento, url_bienestar, nombre_pagina, nombre_pagina, id_menu_lateral)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)
  end
end
