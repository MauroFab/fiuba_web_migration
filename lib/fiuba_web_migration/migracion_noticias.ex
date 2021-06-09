defmodule Migracion_noticias do

  import Utils

  def fecha_format(fecha) do

    if(fecha) do
      Timex.format!(fecha, "%FT%T%:z", :strftime) <> ".000Z"
    else
      "2012-01-01T15:00:00.000Z"
    end
  end


  def noticias do

    noticias = cargar_noticias()

    id_imagen_portada = cargar_imagen("https://testing.cms.fiuba.lambdaclass.com/uploads/Imagenes_noticia_LH_2_da25e81fa7.png")

    Enum.map(
      noticias,
      fn elemento ->

        imagenes_id = []

        imagenes_embebidas = urls_imgs_embebidas( elemento |> Enum.at(0))

        Enum.map(
          imagenes_embebidas,
          fn elemento ->
            imagen_id = cargar_img_embebida(elemento)
            [imagen_id | imagenes_id]

            # list = [1, 2, 3]
            # [0 | list] # fast

          end)

        noticia = %{
          "seo_url" => elemento |> Enum.at(1) |> url_format(),
          "titulo" => Enum.at(elemento, 1),
          "fecha_publicacion" => fecha_format(Enum.at(elemento, 2)),
          "cuerpo" => HtmlSanitizeEx.strip_tags(Enum.at(elemento, 3)),
          "bajada" => String.slice(HtmlSanitizeEx.strip_tags(Enum.at(elemento, 3)), 0, 265) <> "...",
          "portada" => %{
             "id" => id_imagen_portada
             },
          "componentes" => [%{
            "__component" => "paginas.galeria",
            "imagenes" => imagenes_id
          }]
          }

        HTTPoison.post!(
          "https://testing.cms.fiuba.lambdaclass.com/noticias",
          JSON.encode!(noticia),
          [{"Content-type", "application/json"}]
        )

        imagenes_id

      end
    )
  end

end
