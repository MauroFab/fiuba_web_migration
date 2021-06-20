defmodule FiubaWebMigration do

  import Migracion_noticias
  import Migracion_posgrado
  import Migracion_grado
  import Migracion_investigacion
  import Migracion_institucional
  import Migracion_bienestar
  import Migracion_ingresantes
  import Migracion_biblioteca
  import Migracion_prensa
  import Migracion_estudiantes
  import Migracion_docentes
  import Migracion_graduados
  import Migracion_extranjeros
  import Migracion_no_docentes



  def migration() do

    # noticias()

    # posgrado() #ok
    # grado() #ok

    # investigacion() #ok
    # institucional() #ok (REQUIERE BORRAR DOS REGISTROS)
    bienestar() #Ya tiene menúes laterales e incluye recursión con nodos con links
    # ingresantes() #Ya tiene menúes laterales e incluye recursión con nodos con links
    # biblioteca() #Ya tiene menúes laterales e incluye recursión con nodos con links
    # prensa() #Ya tiene menúes laterales e incluye recursión con nodos con links

    # estudiantes() #Ya tiene menúes laterales e incluye recursión con nodos con links
    # docentes() #Ya tiene menúes laterales e incluye recursión con nodos con links
    # graduados() #Ya tiene menúes laterales e incluye recursión con nodos con links
    # extranjeros() #Ya tiene menúes laterales e incluye recursión con nodos con links
    # no_docentes() #Ya tiene menúes laterales e incluye recursión con nodos con links

    #########################    VIEJO   ########################
    # grado() #Ya tiene menúes laterales e incluye recursión con nodos con links (REQUIERE BORRAR UN REGISTRO)
    # maestrias_posgrado() #Ya tiene menúes laterales e incluye recursión con nodos con links (TIENE DATOS BASURA)
    # carreras_especializaciones() #Ya tiene menúes laterales e incluye recursión con nodos con links (TIENE DATOS BASURA)
    # anuales_bianuales() #Ya tiene menúes laterales e incluye recursión con nodos con links

  end
end
