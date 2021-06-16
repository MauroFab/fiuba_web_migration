defmodule Migracion_investigacion do

  import Utils

  def investigacion() do
    investigacion = cargar_nodo_padre_standard(1161) |> Enum.at(0)

    texto_pagina = ""
    nombre_pagina = "Investigación"

    id_pagina_investigacion = crear_pagina(nombre_pagina, texto_pagina, nombre_pagina)

    url_investigacion = "/investigacion"
    crear_navegacion(url_investigacion, nombre_pagina, id_pagina_investigacion)

    investigaciones = investigacion |> Enum.at(0) |> cargar_hijos()

    Enum.map(
      investigaciones,
      fn elemento ->
        busqueda_recursiva(elemento, url_investigacion, nombre_pagina, nombre_pagina)
      end
    )
  end
end
