defmodule FiubaWebMigration do
  import Migracion_noticias
  import Migracion_carrera_grado
  import Migracion_carrera_especializacion
  import Migracion_maestria
  import Migracion_anuales_bianuales
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
    # carreras_grado()
    # maestrias_posgrado()
    # carreras_especializaciones()
    # anuales_bianuales()

    # investigacion()
    # institucional()
    # bienestar()
    # ingresantes()
    # biblioteca()
    # prensa()

    # estudiantes()
    # docentes()
    # graduados()
    # extranjeros()
    no_docentes()
  end
end
