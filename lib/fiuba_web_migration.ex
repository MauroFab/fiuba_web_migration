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


  def fecha_format(fecha) do

    use Timex
    if(fecha) do
      Timex.format!(fecha,"%FT%T%:z", :strftime) <> ".000Z"
    else
      "2020-03-12T15:00:00.000Z"
    end
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
          field_data_body.body_value as TEXTO
      FROM node
      INNER JOIN field_data_body ON  node.nid = field_data_body.entity_id
      LEFT JOIN field_data_field_date ON node.nid = field_data_field_date.entity_id
      WHERE node.type = 'article'
      ORDER BY node.nid
      ")

    noticias = respuesta.rows

    Enum.map(
      noticias,
      fn elemento ->
        noticia = %{
          "seo_url" => to_string(Enum.at(elemento,0)),
          "titulo" => Enum.at(elemento, 1),
          "fecha_publicacion" => fecha_format( Enum.at(elemento,2)),
          "cuerpo" => HtmlSanitizeEx.strip_tags( Enum.at(elemento, 3) ),
          "portada" => %{"id"=>15,"name"=>"Imágenes iconos-09.png","alternativeText"=>"","caption"=>"","width"=>1920,"height"=>508,"formats"=> %{"large"=> %{"ext"=>".png","url"=>"/uploads/large_Imagenes_iconos_09_06e64bf2f5.png","hash"=>"large_Imagenes_iconos_09_06e64bf2f5","mime"=>"image/png","name"=>"large_Imágenes iconos-09.png","size"=>85.31,"width"=>1000,"height"=>265},"small"=> %{"ext"=>".png","url"=>"/uploads/small_Imagenes_iconos_09_06e64bf2f5.png","hash"=>"small_Imagenes_iconos_09_06e64bf2f5","mime"=>"image/png","name"=>"small_Imágenes iconos-09.png","size"=>32.53,"width"=>500,"height"=>132},"medium"=> %{"ext"=>".png","url"=>"/uploads/medium_Imagenes_iconos_09_06e64bf2f5.png","hash"=>"medium_Imagenes_iconos_09_06e64bf2f5","mime"=>"image/png","name"=>"medium_Imágenes iconos-09.png","size"=>58.1,"width"=>750,"height"=>198},"thumbnail"=> %{"ext"=>".png","url"=>"/uploads/thumbnail_Imagenes_iconos_09_06e64bf2f5.png","hash"=>"thumbnail_Imagenes_iconos_09_06e64bf2f5","mime"=>"image/png","name"=>"thumbnail_Imágenes iconos-09.png","size"=>11.9,"width"=>245,"height"=>65}},"hash"=>"Imagenes_iconos_09_06e64bf2f5","ext"=>".png","mime"=>"image/png","size" => 59.05,"url"=>"/uploads/Imagenes_iconos_09_06e64bf2f5.png","provider"=>"local","created_at"=>"2021-03-22T15:06:19.993Z","updated_at"=>"2021-03-22T15:06:20.004Z"}
        }

        HTTPoison.post!(
          "https://testing.cms.fiuba.lambdaclass.com/noticias",
          JSON.encode!(noticia),
          [{"Content-type", "application/json"}]
        )

      end
    )
  end
end
