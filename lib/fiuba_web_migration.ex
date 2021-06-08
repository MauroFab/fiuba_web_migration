defmodule FiubaWebMigration do
  import Migracion_noticias
  import Migracion_carrera_grado
  import Migracion_carrera_especializacion
  import Migracion_maestria
  import Migracion_anuales_bianuales
  import Migracion_investigacion

  def migration() do
    # carreras_grado()
    # maestrias_posgrado()
    carreras_especializaciones()
    # anuales_bianuales()
    # aca falta carreras de especializacion

    # investigacion()
  end
end
