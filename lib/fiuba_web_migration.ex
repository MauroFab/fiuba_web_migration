defmodule FiubaWebMigration do
  @moduledoc """
  Documentation for `FiubaWebMigration`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> FiubaWebMigration.hello()
      :world

  """
  def hello do
    :world
  end

  def noticias_migration do
    alias FiubaWebMigration.Repo
    import Ecto.Query
    import HTTPoison
    import JSON

    {:ok, respuesta} = Repo.query("
      SELECT
          node.nid as NODO,
          node.title as TITULO,
          field_data_field_date.field_date_value AS FECHA,
          field_data_body.body_value as TEXTO,
          REPLACE (file_managed.uri,'public://','www.fi.uba.ar/sites/default/files/') AS PORTADA
      FROM node
      INNER JOIN field_data_body ON  node.nid = field_data_body.entity_id
      LEFT JOIN field_data_field_date ON node.nid = field_data_field_date.entity_id
      LEFT JOIN field_data_field_image ON (node.nid = field_data_field_image.entity_id AND field_data_field_image.bundle = 'article')
      LEFT JOIN file_managed ON field_data_field_image.field_image_fid = file_managed.fid
      WHERE node.type = 'article'
      ORDER BY node.title
      Limit 2
      ")

    noticias = respuesta.rows

    Enum.map(
      noticias,
      fn elemento ->
        noticia = %{
          "titulo" => Enum.at(elemento, 1),
          "cuerpo" => Enum.at(elemento, 3),
          "fecha_publicacion" => "2021-04-27T21:52:39.581Z",
          "seo_url" => to_string(Enum.at(elemento,0))
        }

        IO.puts("json data")
        IO.puts(JSON.encode!(noticia))

        HTTPoison.post!(
          "https://testing.cms.fiuba.lambdaclass.com/noticias",
          JSON.encode!(noticia),
          [{"Content-type", "application/json"}]
        )

        ## Aca tiene que venir el post
      end
    )
  end
end
