defmodule Utils do

  alias FiubaWebMigration.Repo
  import Ecto.Query
  import JSON
  import String
  import HTTPoison.Retry


  def cargar_imagen(url_imagen, nombre_imagen) do
    {:ok, result} =
      HTTPoison.get(url_imagen)
      |> HTTPoison.Retry.autoretry(
        max_attempts: 10,
        wait: 20000,
        include_404s: false,
        retry_unknown_errors: false
      )

    imagen = result.body
    headers = [{"Content-Type", "multipart/form-data"}]
    options = [ssl: [{:versions, [:"tlsv1.2"]}], recv_timeout: 20000]

    {:ok, response_imagen} =
      HTTPoison.request(
        :post,
        "https://testing.cms.fiuba.lambdaclass.com/upload",
        {:multipart,
         [
           {"file", imagen, {"form-data", [name: "files", filename: nombre_imagen <> ".jpg"]},
            [{"Content-Type", "image/jpeg"}]},
           {"type", "image/jpeg"}
         ]},
        headers,
        options
      )
      |> HTTPoison.Retry.autoretry(
        max_attempts: 20,
        wait: 20000,
        include_404s: false,
        retry_unknown_errors: false
      )

    response_body = response_imagen.body
    {:ok, response_body_map} = JSON.decode(response_body)
    {:ok, id_imagen} = Map.fetch(response_body_map |> Enum.at(0), "id")

    id_imagen
  end


  def urls_imgs_embebidas(nid) do
    query_sql = "SELECT
        REPLACE (file_managed.uri,'public://','www.fi.uba.ar/sites/default/files/') AS URL_IMG
      FROM node
      INNER JOIN field_data_field_galeria_embebida ON node.nid = field_data_field_galeria_embebida.entity_id
      LEFT JOIN file_usage ON field_data_field_galeria_embebida.field_galeria_embebida_value = file_usage.id AND file_usage.type = 'field_collection_item'
      LEFT JOIN file_managed ON file_managed.fid = file_usage.fid
      WHERE node.type = 'article' AND node.nid = " <> to_string(nid) <> ";"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end


  def crear_pagina( nombre_pagina \\ "", id_menu_lateral \\ nil , blabla \\ nil) do
    pagina = %{
      "nombre" => nombre_pagina,
      "portada" => 42,
      "menu_lateral" => id_menu_lateral,
      "componentes" => [
        %{
          "__component" => "paginas.texto-con-formato",
          "texto" => ""
        }
      ]
    }

    response_pagina =
      HTTPoison.post!(
        "https://testing.cms.fiuba.lambdaclass.com/paginas",
        JSON.encode!(pagina),
        [{"Content-type", "application/json"}]
      )

      |> HTTPoison.Retry.autoretry(
        max_attempts: 20,
        wait: 20000,
        include_404s: false,
        retry_unknown_errors: false
      )

    response_body = response_pagina.body
    {:ok, response_body_map} = JSON.decode(response_body)
    {:ok, id_pagina} = Map.fetch(response_body_map, "id")

    id_pagina
  end


  def actualizar_pagina(id_pagina, texto_pagina, ids_navs_pag) do

    links = Enum.map(
      ids_navs_pag,
      fn id ->
        %{"navegacion" => id}
      end
    )

    pagina_actualizaciones = %{
      "componentes" => [
        %{
          "__component" => "paginas.texto-con-formato",
          "texto" => (if (texto_pagina == nil) do "" else texto_pagina end)
        },
        %{
          "__component" => "paginas.navegacion-listado",
          "links" => links
        }
      ]
    }

    HTTPoison.put!(
      "https://testing.cms.fiuba.lambdaclass.com/paginas/" <> to_string(id_pagina),
      JSON.encode!(pagina_actualizaciones),
      [{"Content-type", "application/json"}]
    )
    |> HTTPoison.Retry.autoretry(
        max_attempts: 20,
        wait: 20000,
        include_404s: false,
        retry_unknown_errors: false
      )

  end


  def url_format(string) do
    string
    |> String.downcase()
    |> String.normalize(:nfd)
    |> String.replace(~r/[^A-Z^a-z^0-9\s]/u, "")
    |> String.replace(~r/\s/, "-")
  end


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

      |> HTTPoison.Retry.autoretry(
        max_attempts: 20,
        wait: 20000,
        include_404s: false,
        retry_unknown_errors: false
      )

    response_body = response_navegacion.body
    {:ok, response_body_map} = JSON.decode(response_body)
    {:ok, id_navegacion} = Map.fetch(response_body_map, "id")

    id_navegacion
  end


  def crear_menu_lateral(nombre_menu) do
    menu_lateral = %{
      "nombre" => nombre_menu
    }

    response_menu_laterals =
      HTTPoison.post!(
        "https://testing.cms.fiuba.lambdaclass.com/menu-laterals",
        JSON.encode!(menu_lateral),
        [{"Content-type", "application/json"}]
      )

      |> HTTPoison.Retry.autoretry(
        max_attempts: 20,
        wait: 20000,
        include_404s: false,
        retry_unknown_errors: false
      )

    response_body = response_menu_laterals.body
    {:ok, response_body_map} = JSON.decode(response_body)
    {:ok, id_menu_lateral} = Map.fetch(response_body_map, "id")

    id_menu_lateral
  end


  def actualizar_menu_lateral(id_menu_lateral, id_navegaciones) do
    links =
      Enum.map(
        id_navegaciones,
        fn id_navegacion ->
          %{"navegacion" => id_navegacion}
        end
      )

    menu_lateral = %{"links" => links}

    HTTPoison.put!(
      "https://testing.cms.fiuba.lambdaclass.com/menu-laterals/" <> to_string(id_menu_lateral),
      JSON.encode!(menu_lateral),
      [{"Content-type", "application/json"}]
    )

    |> HTTPoison.Retry.autoretry(
        max_attempts: 20,
        wait: 20000,
        include_404s: false,
        retry_unknown_errors: false
      )

  end


  def cargar_hijos(plid) do

    query_sql = "SELECT
    menu_links.mlid AS mlid,
    menu_links.link_title AS titulo,
    menu_links.link_path AS Link_path,
    menu_links.has_children AS tiene_hijos
    FROM menu_links
    WHERE menu_links.plid = " <> to_string(plid) <> " ;"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end


  def cargar_nodo(link_path) do

    if(contains?(link_path,"node/")) do

      link = String.split(link_path, "node/", trim: true)
      nid = List.last(link)

      query_sql = "SELECT
          node.title AS titulo_nodo,
          field_data_body.body_value AS texto_asociado,
          node.nid AS nid,
          node.type AS tipo
        FROM node
        LEFT JOIN field_data_body ON field_data_body.entity_id = node.nid
        WHERE node.nid = " <> nid <> " ;"

        {:ok, respuesta} = Repo.query(query_sql)
        respuesta.rows
    else
      query = "SELECT
        menu_links.link_title AS titulo
        FROM menu_links
        WHERE menu_links.link_path = '" <> link_path <> "' AND menu_links.router_path = '';"

      {:ok, respuesta} = Repo.query(query)

      titulo = respuesta.rows |> Enum.at(0) |> Enum.at(0)
      [[titulo,"","",""]]
    end

  end


  def busqueda_recursiva( elemento, url_nav_padre, id_menu_lateral_padre \\ nil) do
    link_path = elemento |> Enum.at(2)
    nodo = cargar_nodo(link_path) |> Enum.at(0)

    titulo = nodo |> Enum.at(0)
    texto = nodo |> Enum.at(1)
    nodo_type = nodo |> Enum.at(3)

    url_nav = url_nav_padre <> "/" <> (titulo |> url_format())

    # # 1 = Tiene hijos, 0 = No tiene hijos
    has_children = elemento |> Enum.at(3)

    id_menu_lateral = if (has_children == 1) do crear_menu_lateral(url_nav) else id_menu_lateral_padre end
    id_pagina = crear_pagina( titulo, id_menu_lateral)
    id_navegacion = crear_navegacion(url_nav, titulo, id_pagina)

    ids_navs = if (has_children == 1) do
      hijos = elemento |> Enum.at(0) |> cargar_hijos()
      Enum.map(
        hijos,
        fn hijo ->
          busqueda_recursiva(hijo, url_nav, id_menu_lateral)
        end
      )
      else
        []
      end

    ids_navs_pag = if (contains?(nodo_type,"panel")) do ids_navs else [] end

    actualizar_pagina(id_pagina, texto, ids_navs_pag)
    actualizar_menu_lateral(id_menu_lateral, [id_navegacion] ++ ids_navs)

    id_navegacion
  end

end
