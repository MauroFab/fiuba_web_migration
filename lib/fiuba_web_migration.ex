defmodule FiubaWebMigration do

  import Migracion_noticias
  import Migracion_paneles_y_menues
  import Migracion_Archivos
  import Utils

  def migration() do

    # portada_noticias = cargar_imagen("https://testing.cms.fiuba.lambdaclass.com/uploads/Imagenes_noticia_LH_2_da25e81fa7.png","portada_noticias.jpg")
    # noticias()

    id_portada_bienestar = subir_imagen("public/imagenes_portadas_bienestar.png")
    id_portada_posgrado = subir_imagen("public/imagenes_portadas_posgrado.png")
    id_portada_institucional = subir_imagen("public/imagenes_portadas_institucional.png")
    id_portada_investigacion = subir_imagen("public/imagenes_portadas_investigacion.png")
    id_portada_grado = subir_imagen("public/imagenes_portadas_grado.png")

    nodos_raices =
     [
      ["Docentes", "node/285", 906, id_portada_institucional],
      ["Prensa", "node/877", 917, id_portada_institucional],
      ["Biblioteca", "node/1282", 923, id_portada_institucional],
      ["Grado", "node/447", 1154, id_portada_grado],
      ["Posgrado", "node/448", 1155, id_portada_posgrado],
      ["Investigación", "node/452" ,1161, id_portada_investigacion],
      ["Bienestar", "node/453", 1162, id_portada_bienestar],
      ["Institucional", "node/514", 1225, id_portada_institucional],
      ["Ingresantes", "node/744", 1599], id_portada_institucional,
      ["Estudiantes", "node/745", 1600, id_portada_institucional],
      ["Extranjeros", "node/747", 1602, id_portada_institucional],
      ["Nodocentes", "node/749", 1604, id_portada_institucional],
      ["Transparencia", "node/1739", 2536, id_portada_institucional],
      ["Graduados", "node/2602", 2716, id_portada_institucional]
    ]

    Enum.map(
      nodos_raices,
      fn nodo_raiz ->
        id_imagen_asociada = nodo_raiz |> Enum.at(3)
        procesar_nodo_raiz(nodo_raiz, id_imagen_asociada)
      end
    )

    paneles()
    menues_laterales()

  end
end
