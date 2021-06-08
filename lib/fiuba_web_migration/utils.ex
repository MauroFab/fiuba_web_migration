defmodule Utils do
  alias FiubaWebMigration.Repo
  import Ecto.Query
  import JSON
  import String

  def cargar_maestrias do
    query_sql = "SELECT
        menu_links.link_title AS titulo,
        menu_links.mlid AS mlid
      FROM menu_links
      WHERE menu_links.plid = '1157'
      ORDER BY menu_links.link_title DESC"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end

  def cargar_anuales_bianuales do
    query_sql = "SELECT
        menu_links.link_title AS titulo,
        menu_links.mlid AS mlid
      FROM menu_links
      WHERE menu_links.plid = 1159
      ORDER BY menu_links.link_title DESC"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end

  def cargar_investigaciones() do
    query_sql = "SELECT
        menu_links.link_title AS titulo,
        menu_links.mlid AS mlid
      FROM menu_links
      WHERE menu_links.plid = 1161 AND menu_links.router_path = 'node/%';"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end

  def cargar_investigaciones_hijos(plid) do
    query_sql =
      "SELECT
        menu_links.link_title AS titulo,
        menu_links.mlid AS mlid
      FROM menu_links
      WHERE menu_links.plid = " <>
        to_string(plid) <>
        " AND menu_links.has_children = 0
        AND menu_links.router_path = 'node/%';"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end

  def cargar_nodos_asociados_maestrias(mlid) do
    query_sql =
      "SELECT
        menu_links.link_title AS titulo_nodo_asociado,
        REPLACE(menu_links.link_path, 'node/','') AS nid
      FROM menu_links
      WHERE (menu_links.plid = " <>
        to_string(mlid) <> " OR menu_links.mlid = " <> to_string(mlid) <> ");"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end

  def cargar_nodos_asociados(mlid) do
    query_sql =
      "SELECT
        menu_links.link_title AS titulo_nodo_asociado,
        REPLACE(menu_links.link_path, 'node/','') AS nid
      FROM menu_links
      WHERE menu_links.link_title != 'Video' AND
            menu_links.link_title != 'Plan de estudios' AND
            menu_links.link_title != 'Autoridades' AND
            (menu_links.plid = " <>
        to_string(mlid) <> " OR menu_links.mlid = " <> to_string(mlid) <> ");"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end

  def cargar_texto_asociado(nid) do
    query_sql = "SELECT
        node.title AS titulo_nodo,
        field_data_body.body_value AS texto_asociado
      FROM node
      INNER JOIN field_data_body ON field_data_body.entity_id = node.nid
      WHERE node.nid = " <> to_string(nid) <> ";"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end

  # def ejemplo_completo_carreras_grado do

  #   carreras = cargar_carreras_grado()

  #   Enum.map(
  #     carreras,
  #     fn carrera ->
  #       nodos_asociados = cargar_nodos_asociados(Enum.at(carrera, 1))
  #       nombre_carrera = Enum.at(carrera, 0)

  #       componentes_pagina =
  #         Enum.map(
  #           nodos_asociados,
  #           fn nodo ->
  #             texto_asociado = Enum.at(cargar_texto_asociado(Enum.at(nodo, 1)), 0)

  #             %{
  #               "__component" => "paginas.texto-con-formato",
  #               "texto" => HtmlSanitizeEx.strip_tags(Enum.at(texto_asociado, 1)),
  #               "encabezado" =>
  #                 if Enum.at(texto_asociado, 0) == nombre_carrera do
  #                   "Propuesta Académica"
  #                 else
  #                   Enum.at(texto_asociado, 0)
  #                 end
  #             }
  #           end
  #         )

  #       # POR CADA CARRERA CREO UNA PAGINA
  #       pagina = %{
  #         "componentes" => componentes_pagina,
  #         "nombre" => nombre_carrera
  #       }

  #       response_pagina =
  #         HTTPoison.post!(
  #           "https://testing.cms.fiuba.lambdaclass.com/paginas",
  #           JSON.encode!(pagina),
  #           [{"Content-type", "application/json"}]
  #         )

  #       response_body = response_pagina.body
  #       {:ok, response_body_map} = JSON.decode(response_body)
  #       {:ok, id} = Map.fetch(response_body_map, "id")

  #       # POR CADA PAGINA CREO UN VINCULO

  #       vinculo = %{
  #         "vinculo" => [
  #           %{
  #             "__component" => "navegacion.pagina",
  #             "pagina" => id
  #           }
  #         ],
  #         "seo_url" =>
  #           "/ensenanza/grado/carreras/" <>
  #             (nombre_carrera
  #              |> String.downcase()
  #              |> String.normalize(:nfd)
  #              |> String.replace(~r/[^A-z\s]/u, "")
  #              |> String.replace(~r/\s/, "-")),
  #         "nombre" => nombre_carrera
  #       }

  #       response_navegacion =
  #         HTTPoison.post!(
  #           "https://testing.cms.fiuba.lambdaclass.com/navegacion",
  #           JSON.encode!(vinculo),
  #           [{"Content-type", "application/json"}]
  #         )

  #       response_body_navegacion = response_navegacion.body
  #       {:ok, response_body_navegacion_map} = JSON.decode(response_body_navegacion)
  #       {:ok, id_navegacion} = Map.fetch(response_body_navegacion_map, "id")

  #       pagina_carrera_response =
  #         HTTPoison.get!("https://testing.cms.fiuba.lambdaclass.com/paginas?nombre=Carreras")

  #       pagina_carrera_response_body = pagina_carrera_response.body
  #       {:ok, response_body_carreras_map} = JSON.decode(pagina_carrera_response_body)
  #       {:ok, id_pagina_carrera} = Map.fetch(Enum.at(response_body_carreras_map, 0), "id")

  #       {:ok, componentes_actuales} =
  #         Map.fetch(Enum.at(response_body_carreras_map, 0), "componentes")

  #       {:ok, links_actuales} = Map.fetch(Enum.at(componentes_actuales, 0), "links")

  #       link = %{
  #         "updid" => id_pagina_carrera,
  #         "componentes" => [
  #           %{
  #             "__component" => "paginas.navegacion-listado",
  #             "links" => links_actuales ++ [%{"navegacion" => id_navegacion}]
  #           }
  #         ]
  #       }

  #       # {"nombre":"Carreras","created_at":"2021-04-13T19:45:16.763Z","componentes":[{"__component":"paginas.navegacion-listado","id":3,"encabezado":null,"links":[{"id":4,"navegacion":40},{"navegacion":68}]}],"created_by":1,"menu_lateral":null,"updated_at":"2021-06-02T03:08:45.832Z","id":24,"updated_by":4,"portada":46}

  #       HTTPoison.put!(
  #         "https://testing.cms.fiuba.lambdaclass.com/paginas/" <> to_string(id_pagina_carrera),
  #         JSON.encode!(link),
  #         [{"Content-type", "application/json"}]
  #       )
  #     end
  #   )
  # end

  def crear_pagina(nombre_pagina, texto_pagina \\ "") do
    pagina = %{
      "nombre" => nombre_pagina,
      "componentes" => [
        %{
          "__component" => "paginas.texto-con-formato",
          "texto" => HtmlSanitizeEx.strip_tags(texto_pagina)
        }
      ]
    }

    response_pagina =
      HTTPoison.post!(
        "https://testing.cms.fiuba.lambdaclass.com/paginas",
        JSON.encode!(pagina),
        [{"Content-type", "application/json"}]
      )

    response_body = response_pagina.body
    {:ok, response_body_map} = JSON.decode(response_body)
    {:ok, id_pagina} = Map.fetch(response_body_map, "id")

    id_pagina
  end

  def url_format(string) do
    string
    |> String.downcase()
    |> String.normalize(:nfd)
    |> String.replace(~r/[^A-z\s]/u, "")
    |> String.replace(~r/\s/, "-")
  end

  @doc """
  Recibe la url generica, el nombre de la navegacion y el id de la pagina a vincular.
  Ejemplo url: /ensenanza/grado/carreras/, nombre_navegacion: "Ingeniería Informática", id_pagina: 27
  """
  def crear_navegacion(url_navegacion, nombre_navegacion, id_pagina) do
    vinculo = %{
      "vinculo" => [
        %{
          "__component" => "navegacion.pagina",
          "pagina" => id_pagina
        }
      ],
      "seo_url" => url_navegacion,
      "nombre" => nombre_navegacion
    }

    response_navegacion =
      HTTPoison.post!(
        "https://testing.cms.fiuba.lambdaclass.com/navegacion",
        JSON.encode!(vinculo),
        [{"Content-type", "application/json"}]
      )
  end
end
