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


  def migration() do
    
    #noticias()

    #carreras_grado()
    #maestrias_posgrado()
    #carreras_especializaciones()
    #anuales_bianuales()
    
    #investigacion()
    #institucional()
    #bienestar()
    #ingresantes()
    #biblioteca()
    prensa()

  end
end
