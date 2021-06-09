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

    # binary_file_content = "Something you fetched and now have it in memory"
    # headers = [{"Content-Type", "multipart/form-data"}]
    # options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 2000]

    # HTTPoison.request(
    #   :post,
    #   "https://testing.cms.fiuba.lambdaclass.com/upload",
    #   {:multipart,
    #    [{"file", binary_file_content, {"form-data", [name: "files", filename: "a_file_name.txt"]}, []}]},
    #   headers,
    #   options
    # )

  end
end
