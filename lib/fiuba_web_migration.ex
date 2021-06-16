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

    # noticias() #Ya trae noticias e imágenes (tarda mucho)

    # carreras_grado() #Ya tiene menúes laterales
    # maestrias_posgrado() #Ya tiene menúes laterales
    # carreras_especializaciones() #No trae bien
    # anuales_bianuales() #No trae bien

    # investigacion() #No trae bien
    # institucional() #No trae bien
    # bienestar() #Ya tiene menúes laterales
    # ingresantes() #Ya tiene menúes laterales
    # biblioteca() #Ya tiene menúes laterales
    # prensa() #Ya tiene menúes laterales

    # estudiantes() #Ya tiene menúes laterales
    # docentes() #Ya tiene menúes laterales
    # graduados() #Ya tiene menúes laterales
    # extranjeros() #Ya tiene menúes laterales
    # no_docentes() #Ya tiene menúes laterales

  end
end
