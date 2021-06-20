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
    # bienestar() #ok
    # ingresantes() #ok
    # biblioteca() #ok
    # prensa() #ok

    # estudiantes() #ok
    # docentes() #ok
    # graduados() #ok
    # extranjeros() #ok
    # no_docentes() #ok

  end
end
