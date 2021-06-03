defmodule FiubaWebMigration do
  @moduledoc """
  Documentation for `FiubaWebMigration`.
  """

  @doc """
    Hello world.

    ## Examples

        iex> FiubaWebMigration.hello()
        :world


    def hello do
      :world
    end

    """


  def cargar_carreras_grado do
    alias FiubaWebMigration.Repo
    import Ecto.Query

    query_sql = "SELECT
        menu_links.link_title AS titulo,
        menu_links.mlid AS mlid
      FROM menu_links
      WHERE menu_links.plid = '1018'
      ORDER BY menu_links.link_title DESC
      LIMIT 1"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end

  def cargar_nodos_asociados(mlid) do
    alias FiubaWebMigration.Repo
    import Ecto.Query

    query_sql =
      "SELECT
        menu_links.link_title AS titulo_nodo_asociado,
        REPLACE(menu_links.link_path, 'node/','') AS nid
      FROM menu_links
      WHERE menu_links.link_title != 'Video' AND
            menu_links.link_title != 'Plan de estudios' AND
            menu_links.link_title != 'Autoridades' AND
            (menu_links.plid = " <> to_string(mlid) <> " OR menu_links.mlid = " <> to_string(mlid) <> ");"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end

  def cargar_texto_asociado(nid) do
    alias FiubaWebMigration.Repo
    import Ecto.Query

    query_sql = "SELECT
        node.title AS titulo_nodo,
        field_data_body.body_value AS texto_asociado
      FROM node
      INNER JOIN field_data_body ON field_data_body.entity_id = node.nid
      WHERE node.nid = " <> to_string(nid) <> ";"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end

  def pepito do
    alias FiubaWebMigration.Repo
    import Ecto.Query
    import JSON
    import String

    carreras = cargar_carreras_grado()

    Enum.map(
      carreras,
      fn carrera ->
        nodos_asociados = cargar_nodos_asociados(Enum.at(carrera, 1))
        nombre_carrera = Enum.at(carrera, 0)

        componentes_pagina =
          Enum.map(
            nodos_asociados,
            fn nodo ->
              texto_asociado = Enum.at(cargar_texto_asociado(Enum.at(nodo, 1)), 0)

              %{
                "__component" => "paginas.texto-con-formato",
                "texto" => HtmlSanitizeEx.strip_tags(Enum.at(texto_asociado, 1)),
                "encabezado" =>
                  if Enum.at(texto_asociado, 0) == nombre_carrera do
                    "Propuesta Académica"
                  else
                    Enum.at(texto_asociado, 0)
                  end
              }
            end
          )

        # POR CADA CARRERA CREO UNA PAGINA
        pagina = %{
          "componentes" => componentes_pagina,
          "nombre" => nombre_carrera
        }

        response_pagina =
          HTTPoison.post!(
            "https://testing.cms.fiuba.lambdaclass.com/paginas",
            JSON.encode!(pagina),
            [{"Content-type", "application/json"}]
          )

        response_body = response_pagina.body
        {:ok, response_body_map} = JSON.decode(response_body)
        {:ok, id} = Map.fetch(response_body_map, "id")

        # POR CADA PAGINA CREO UN VINCULO

        vinculo = %{
          "vinculo" => [
            %{
              "__component" => "navegacion.pagina",
              "pagina" => id
            }
          ],
          "seo_url" =>
            "/ensenanza/grado/carreras/" <>
              (nombre_carrera
               |> String.downcase()
               |> String.normalize(:nfd)
               |> String.replace(~r/[^A-z\s]/u, "")
               |> String.replace(~r/\s/, "-")),
          "nombre" => nombre_carrera
        }

        response_navegacion =
          HTTPoison.post!(
            "https://testing.cms.fiuba.lambdaclass.com/navegacion",
            JSON.encode!(vinculo),
            [{"Content-type", "application/json"}]
          )

        response_body_navegacion = response_navegacion.body
        {:ok, response_body_navegacion_map} = JSON.decode(response_body_navegacion)
        {:ok, id_navegacion} = Map.fetch(response_body_navegacion_map, "id")

        HTTPoison.post!(
          "https://testing.cms.fiuba.lambdaclass.com/navegacion",
          JSON.encode!(vinculo),
          [{"Content-type", "application/json"}]
        )

        pagina_carrera_response =
          HTTPoison.get!("https://testing.cms.fiuba.lambdaclass.com/paginas?nombre=Carreras")

        pagina_carrera_response_body = pagina_carrera_response.body
        {:ok, response_body_carreras_map} = JSON.decode(pagina_carrera_response_body)
        {:ok, id_pagina_carrera} = Map.fetch(Enum.at(response_body_carreras_map, 0), "id")

        {:ok, componentes_actuales} =
          Map.fetch(Enum.at(response_body_carreras_map, 0), "componentes")

        {:ok, links_actuales} = Map.fetch(Enum.at(componentes_actuales, 0), "links")

        link = %{
          "updid" => id_pagina_carrera,
          "componentes" => [
            %{
              "__component" => "paginas.navegacion-listado",
              "links" => links_actuales ++ [%{"navegacion" => id_navegacion}]
            }
          ]
        }

        # {"nombre":"Carreras","created_at":"2021-04-13T19:45:16.763Z","componentes":[{"__component":"paginas.navegacion-listado","id":3,"encabezado":null,"links":[{"id":4,"navegacion":40},{"navegacion":68}]}],"created_by":1,"menu_lateral":null,"updated_at":"2021-06-02T03:08:45.832Z","id":24,"updated_by":4,"portada":46}

        HTTPoison.put!(
          "https://testing.cms.fiuba.lambdaclass.com/paginas/" <> to_string(id_pagina_carrera),
          JSON.encode!(link),
          [{"Content-type", "application/json"}]
        )
      end
    )
  end

  def fecha_format(fecha) do
    use Timex

    if(fecha) do
      Timex.format!(fecha, "%FT%T%:z", :strftime) <> ".000Z"
    else
      "2012-01-01T15:00:00.000Z"
    end
  end

  def noticias_migration do
    alias FiubaWebMigration.Repo
    import Ecto.Query
    import HTTPoison
    import JSON
    import String

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
          "seo_url" => to_string(Enum.at(elemento, 0)),
          "titulo" => Enum.at(elemento, 1),
          "fecha_publicacion" => fecha_format(Enum.at(elemento, 2)),
          "cuerpo" => HtmlSanitizeEx.strip_tags(Enum.at(elemento, 3)),
          "bajada" => slice(HtmlSanitizeEx.strip_tags(Enum.at(elemento, 3)), 0, 265) <> "...",
          "portada" => %{
            "id" => 15,
            "name" => "Imágenes iconos-09.png",
            "alternativeText" => "",
            "caption" => "",
            "width" => 1920,
            "height" => 508,
            "formats" => %{
              "large" => %{
                "ext" => ".png",
                "url" => "/uploads/large_Imagenes_iconos_09_06e64bf2f5.png",
                "hash" => "large_Imagenes_iconos_09_06e64bf2f5",
                "mime" => "image/png",
                "name" => "large_Imágenes iconos-09.png",
                "size" => 85.31,
                "width" => 1000,
                "height" => 265
              },
              "small" => %{
                "ext" => ".png",
                "url" => "/uploads/small_Imagenes_iconos_09_06e64bf2f5.png",
                "hash" => "small_Imagenes_iconos_09_06e64bf2f5",
                "mime" => "image/png",
                "name" => "small_Imágenes iconos-09.png",
                "size" => 32.53,
                "width" => 500,
                "height" => 132
              },
              "medium" => %{
                "ext" => ".png",
                "url" => "/uploads/medium_Imagenes_iconos_09_06e64bf2f5.png",
                "hash" => "medium_Imagenes_iconos_09_06e64bf2f5",
                "mime" => "image/png",
                "name" => "medium_Imágenes iconos-09.png",
                "size" => 58.1,
                "width" => 750,
                "height" => 198
              },
              "thumbnail" => %{
                "ext" => ".png",
                "url" => "/uploads/thumbnail_Imagenes_iconos_09_06e64bf2f5.png",
                "hash" => "thumbnail_Imagenes_iconos_09_06e64bf2f5",
                "mime" => "image/png",
                "name" => "thumbnail_Imágenes iconos-09.png",
                "size" => 11.9,
                "width" => 245,
                "height" => 65
              }
            },
            "hash" => "Imagenes_iconos_09_06e64bf2f5",
            "ext" => ".png",
            "mime" => "image/png",
            "size" => 59.05,
            "url" => "/uploads/Imagenes_iconos_09_06e64bf2f5.png",
            "provider" => "local",
            "created_at" => "2021-03-22T15:06:19.993Z",
            "updated_at" => "2021-03-22T15:06:20.004Z"
          }
        }

        HTTPoison.post!(
          "https://testing.cms.fiuba.lambdaclass.com/noticias",
          JSON.encode!(noticia),
          [{"Content-type", "application/json"}]
        )
      end
    )
  end

  def cargar_carreras_especializacion do
    alias FiubaWebMigration.Repo
    import Ecto.Query
    import HTTPoison

    query_sql = "SELECT
        menu_links.link_title AS titulo,
        menu_links.mlid AS mlid
      FROM menu_links
      WHERE menu_links.plid = '1158'
      ORDER BY menu_links.link_title DESC
      Limit 2"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end

  def cargar_nodos_asociados_carreras_especializadas(mlid) do
    alias FiubaWebMigration.Repo
    import Ecto.Query

    query_sql =
      "SELECT
        menu_links.link_title AS titulo_nodo_asociado,
        REPLACE(menu_links.link_path, 'node/','') AS nid
      FROM menu_links
      WHERE menu_links.plid = " <>
        to_string(mlid) <> " OR menu_links.mlid = " <> to_string(mlid) <> ";"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end

  def menen() do
    especializaciones = cargar_carreras_especializacion()

    Enum.map(
      especializaciones,
      fn especializacion ->
        nodos_asociados =
          cargar_nodos_asociados_carreras_especializadas(Enum.at(especializacion, 1))

        Enum.map(
          nodos_asociados,
          fn nodo ->
            texto_nodo = cargar_texto_asociado(Enum.at(nodo, 1))
          end
        )
      end
    )
  end



  def carreras_grado_migration() do

    alias FiubaWebMigration.Repo
    import Ecto.Query
    import HTTPoison

    carreras = cargar_carreras_grado()

    Enum.map(
      carreras,
      fn carrera ->
        nodos_asociados = cargar_nodos_asociados(Enum.at(carrera, 1))
        nombre_carrera = Enum.at(carrera, 0)

        componentes_pagina =
          Enum.map(
            nodos_asociados,
            fn nodo ->
              texto_asociado = Enum.at(cargar_texto_asociado(Enum.at(nodo, 1)), 0)

              paginas = %{
                "nombre" => if (String.contains?(Enum.at(texto_asociado,0), nombre_carrera)) do nombre_carrera else (nombre_carrera <> " - " <> Enum.at(texto_asociado,0)) end,
                "componentes" => %{
                  "__component" => "paginas.texto-con-formato",
                  "texto" => HtmlSanitizeEx.strip_tags(Enum.at(texto_asociado, 1))
                }
              }
            end
          )
      end)
  end


  def hello do
      :world
  end

end
