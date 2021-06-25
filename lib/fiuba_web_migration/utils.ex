defmodule Utils do
  alias FiubaWebMigration.Repo
  import Ecto.Query
  import JSON
  import String
  import HTTPoison.Retry

  def carga_nodos_raices() do
    query_sql = "SELECT
        menu_links.link_title AS TITULO,
        menu_links.link_path AS PATH,
        menu_links.mlid AS MLID
      FROM menu_links
      WHERE
        menu_links.plid = 0 AND
        menu_links.router_path = 'node/%' AND
        menu_links.mlid > 900 AND
        menu_links.link_title != 'Noticias'
      ORDER BY menu_links.mlid DESC;"

    {:ok, respuesta} = Repo.query(query_sql)
    respuesta.rows
  end

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

  def crear_pagina( nombre_pagina \\ "", texto_pagina, id_menu_lateral \\ nil , id_imagen_portada \\ nil) do

    pagina = %{
      "nombre" => nombre_pagina,
      "portada" => id_imagen_portada,
      "menu_lateral" => id_menu_lateral,
      "componentes" => [
        %{
          "__component" => "paginas.texto-con-formato",
          "texto" => (if (texto_pagina == nil) do "" else parcer(texto_pagina) end)
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
        max_attempts: 40,
        wait: 20000,
        include_404s: false,
        retry_unknown_errors: false
      )

    response_body = response_pagina.body
    {:ok, response_body_map} = JSON.decode(response_body)
    {:ok, id_pagina} = Map.fetch(response_body_map, "id")

    id_pagina
  end

  def url_format(string) do
    string
    |> String.trim()
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
      # |> HTTPoison.Retry.autoretry(
      #   max_attempts: 40,
      #   wait: 20000,
      #   include_404s: false,
      #   retry_unknown_errors: false
      # )

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
    if(contains?(link_path, "node/")) do
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
      [[titulo, "", "", ""]]
    end
  end

  def busqueda_recursiva(
        elemento,
        url_nav_padre,
        id_menu_lateral_padre \\ nil,
        id_imagen_portada \\ nil
      ) do
    link_path = elemento |> Enum.at(2)
    nodo = cargar_nodo(link_path) |> Enum.at(0)

    titulo = nodo |> Enum.at(0)
    texto = nodo |> Enum.at(1)
    nodo_type = nodo |> Enum.at(3)

    url_nav = url_nav_padre <> "/" <> (titulo |> url_format())

    # # 1 = Tiene hijos, 0 = No tiene hijos
    has_children = elemento |> Enum.at(3)

    id_menu_lateral = if (has_children == 1) do crear_menu_lateral(url_nav) else id_menu_lateral_padre end
    id_pagina = crear_pagina( titulo, texto, id_menu_lateral, id_imagen_portada)

    id_navegacion = crear_navegacion(url_nav, titulo, id_pagina)

    ids_navs =
      if has_children == 1 do
        hijos = elemento |> Enum.at(0) |> cargar_hijos()

        Enum.map(
          hijos,
          fn hijo ->
            busqueda_recursiva(hijo, url_nav, id_menu_lateral, id_imagen_portada)
          end
        )
      else
        []
      end

    actualizar_menu_lateral(id_menu_lateral, ids_navs)

    id_navegacion
  end


  def procesar_nodo_raiz(nodo_raiz, id_portada_paginas) do

    nombre_pagina = nodo_raiz |> Enum.at(0)
    nodo = nodo_raiz |> Enum.at(1) |> cargar_nodo() |> Enum.at(0)
    hijos = nodo_raiz |> Enum.at(2) |> cargar_hijos()

    texto_pagina = nodo |> Enum.at(1)
    url_pagina = "/" <> (nombre_pagina |> url_format())

    id_menu_lateral = crear_menu_lateral(url_pagina)
    id_pagina = crear_pagina(nombre_pagina, texto_pagina, id_menu_lateral, id_portada_paginas)
    id_navegacion = crear_navegacion(url_pagina, nombre_pagina, id_pagina)

    ids_navs = Enum.map(
      hijos,
      fn hijo ->
        busqueda_recursiva(hijo, url_pagina, id_menu_lateral, id_portada_paginas)
      end
    )
    actualizar_menu_lateral(id_menu_lateral, ids_navs)

  end


  def formatear_link(linea) do
    # IO.puts(linea)

    porciones = String.split(linea, ~r/[>,<]/, trim: true)

    indice =
      Enum.find_index(
        porciones,
        fn porcion ->
          contains?(porcion, "a href=")
        end
      )

    IO.puts(indice)

    texto = porciones |> Enum.at(indice + 1)

    link =
      porciones
      |> Enum.at(indice)
      |> String.replace([~s{a href=}, ~s{"}, ~s{target="_blank"}], "")

    final = ~s/[#{texto}](#{link})/

    final
  end

  def formatear_negrita(linea) do
    String.replace(linea, ["<strong>", "</strong>"], "**")
  end

  def formatear_head(linea) do
    linea
  end

  def adaptar_linea(linea_sucia) do
    linea = linea_sucia

    linea =
      if(String.contains?(linea, "<strong>")) do
        # IO.puts("strong")
        formatear_negrita(linea)
      else
        linea
      end

    linea =
      if(String.contains?(linea, "<a") && !String.contains?(linea, ">Ver video<")) do
        # IO.puts("link")
        formatear_link(linea)
      else
        linea |> String.replace(["Ver video", "\n\n"], "")
      end

    linea =
      if(String.contains?(linea, "<h")) do
        # IO.puts("head")
        formatear_head(linea)
      else
        linea
      end

    # IO.puts("linea finalizada")
    # IO.puts(linea)
    linea
  end

  def parcer(texto) do
    # temp = ~s{<p><strong>Contacto:</strong><br />\r\nInt.:&nbsp;50404<br />\r\nDelegado general: Sr. Alejandro Marasco<br />\r\nCorreo electrónico:&nbsp;<a href=\"mailto:apuba@fi.uba.ar\">apuba@fi.uba.ar</a>&nbsp;<br />\r\n<a href=\"https://cifiuba.com/\">Sitio web</a>&nbsp;</p>\r\n\r\n<p> </p>\r\n\r\n<p> </p>\r\n}

    lineas_limpias =
      Enum.map(
        String.split(texto, "\r\n", trim: true),
        fn linea ->
          adaptar_linea(linea)
        end
      )

    cuerpo = HtmlSanitizeEx.strip_tags(Enum.join(lineas_limpias, "\n\n"))

    cuerpo
  end
end
