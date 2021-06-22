defmodule Migracion_noticias do

  alias FiubaWebMigration.Repo
  import Utils


  def cargar_noticias() do

    query_sql = "SELECT
        node.nid as NODO,
        node.title as TITULO,
        field_data_field_date.field_date_value AS FECHA,
        field_data_body.body_value as TEXTO
      FROM node
      INNER JOIN field_data_body ON  node.nid = field_data_body.entity_id
      LEFT JOIN field_data_field_date ON node.nid = field_data_field_date.entity_id
      WHERE node.type = 'article' AND node.status = 1
      ORDER BY field_data_field_date.field_date_value DESC;"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end


  def fecha_format(fecha) do
    if(fecha) do
      Timex.format!(fecha, "%FT%T%:z", :strftime) <> ".000Z"
    else
      "2012-01-01T15:00:00.000Z"
    end
  end


  def noticias(id_imagen_portada) do

    noticias = cargar_noticias()

    Enum.map(
      noticias,
      fn noticia ->
        url_imgs = noticia |> Enum.at(0) |> urls_imgs_embebidas()
        url_noticia = (noticia |> Enum.at(1) |> url_format()) <> "-" <> (noticia |> Enum.at(0)|> to_string())


        imagenes_id = Enum.map(
          url_imgs,
          fn elemento ->

            url_img = elemento |> Enum.at(0) |> String.replace(" ","%20")
            cargar_imagen(url_img,url_noticia)
          end
          )

        noticia_body = %{
          "seo_url" => url_noticia,
          "titulo" => noticia |> Enum.at(1),
          "fecha_publicacion" => noticia |> Enum.at(2) |> fecha_format(),
          "cuerpo" => HtmlSanitizeEx.strip_tags(Enum.at(noticia, 3)),
          "bajada" =>
            (noticia |> Enum.at(3) |> HtmlSanitizeEx.strip_tags() |> String.slice(0, 265)) <>
              "...",
          "portada" => %{
            "id" => id_imagen_portada
          },
          "componentes" => [
            %{
              "__component" => "paginas.galeria",
              "imagenes" => imagenes_id
            }
          ]
        }

        HTTPoison.post!(
          "https://testing.cms.fiuba.lambdaclass.com/noticias",
          JSON.encode!(noticia_body),
          [{"Content-type", "application/json"}]
        )
      end
    )
  end
end
