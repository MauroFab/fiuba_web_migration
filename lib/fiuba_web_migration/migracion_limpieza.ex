defmodule Migracion_Limpieza do
  alias FiubaWebMigration.Repo
  # import Ecto.Query
  import JSON
  import String
  import HTTPoison.Retry

  def limpiar_coleccion(url_coleccion, limit \\ "-1") do
    url_base = "https://testing.cms.fiuba.lambdaclass.com"
    url = url_base <> url_coleccion <> "/?_limit=" <> limit

    # :timer.sleep(300)

    {:ok, result} = HTTPoison.get(url)

    coleccion =
      if result.status_code == 200 do
        {:ok, result_body} = JSON.decode(result.body)
        result_body
      else
        []
      end

    if Enum.count(coleccion) > 0 do
      Enum.map(coleccion, fn e ->
        {:ok, response} = HTTPoison.delete(url_base <> url_coleccion <> "/#{Map.get(e, "id")}")

        # IO.puts("ID: #{Map.get(e, "id")} - URL: #{Map.get(e, "url")} ")
      end)
    end
  end
end
