defmodule FiubaWebMigration do

  import Migracion_noticias
  import Migracion_paneles_y_menues
  import Migracion_Archivos
  import Utils

  def migration() do

    # portada_noticias = cargar_imagen("https://testing.cms.fiuba.lambdaclass.com/uploads/Imagenes_noticia_LH_2_da25e81fa7.png","portada_noticias.jpg")
    # noticias()

    # portada_paginas = cargar_imagen("https://testing.cms.fiuba.lambdaclass.com/uploads/Imagenes_noticia_institucional_dcdabf29f7.png", "portada_paginas.jpg")
    nodos_raices = carga_nodos_raices()

    Enum.map(
      nodos_raices,
      fn nodo_raiz ->
        procesar_nodo_raiz(nodo_raiz)#, portada_paginas)
      end
    )

    paneles()
    menues_laterales()

  end
end
