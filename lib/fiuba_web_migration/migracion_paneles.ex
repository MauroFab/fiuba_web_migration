defmodule Migracion_paneles do

  alias FiubaWebMigration.Repo
  import Ecto.Query
  import JSON
  import String
  import HTTPoison.Retry

    # 447,Grado, /grado
    # 448,Posgrado, /podgrado
    # 452,Investigación, /investigacion
    # 453,Bienestar, /bienestar
    # 514,Institucional, /institucional
    # 656,Colección Biblioteca Ingeniería
    # 685,Institucionales (institucional/videoteca/institucionales) NO
    # 726,Ciclo de ensayos (institucional/videoteca/ciclo de ensayor) NO
    # 727,Videoentrevistas (institucional/videoteca/videoentrevistas) NO
    # 888,Videoteca (institucional/videoteca) NO
    # 1282,Biblioteca, /biblioteca
    # 1712,Orientación Vocacional y Educativa (institucional/videoteca/inclusion, genero, bienestar y articulacion social / orientacion vocacional y educativa)
    # 2473,English website
    # 2602,Graduados, /graduados
    # 2827,Revista .ing
    # 2961,Decanato
    # 3213,Orgullosamente FIUBA


  def traer_id_pagina(navegacion_seo_url) do

    response_pagina = HTTPoison.get!("https://testing.cms.fiuba.lambdaclass.com/navegacion?seo_url=" <> navegacion_seo_url)

    |> HTTPoison.Retry.autoretry(
        max_attempts: 20,
        wait: 20000,
        include_404s: false,
        retry_unknown_errors: false
      )

    response_body = response_pagina.body

    {:ok, response_body_map} = JSON.decode(response_body)
    {:ok, vinculo} = Map.fetch(response_body_map |> Enum.at(0), "vinculo")
    {:ok, pagina} = Map.fetch( vinculo |> Enum.at(0), "pagina" )
    {:ok, id_pagina} = Map.fetch( pagina , "id" )

    id_pagina

  end

  def traer_id_navegacion(navegacion_seo_url) do

    response_pagina = HTTPoison.get!("https://testing.cms.fiuba.lambdaclass.com/navegacion?seo_url=" <> navegacion_seo_url)

    response_body = response_pagina.body
    {:ok, response_body_map} = JSON.decode(response_body)
    {:ok, id_nav} = Map.fetch(response_body_map |> Enum.at(0), "id")

    id_nav

  end

  def actualizar_pagina(id_pagina, ids_navs_pag) do

    links = Enum.map(
      ids_navs_pag,
      fn id ->
        %{"navegacion" => id}
      end
    )

    pagina_actualizaciones = %{
      "componentes" => [
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

  def paneles() do

    elementos =
      [
        # ["/institucional",
        #   [
        #     "/institucional/sedes/paseo-colon",
        #     "/institucional/sedes/las-heras",
        #     "/institucional/sedes/ciudad-universitaria"
        #   ]
        # ],
        # ["/grado",
        #   [
        #     "/grado/carreras/ingenieria-civil",
        #     "/grado/carreras/ingenieria-de-alimentos",
        #     "/grado/carreras/ingenieria-electricista-",
        #     "/grado/carreras/ingenieria-electronica-",
        #     "/grado/carreras/ingenieria-en-agrimensura",
        #     "/grado/carreras/ingenieria-en-informatica-",
        #     "/grado/carreras/ingenieria-en-petroleo",
        #     "/grado/carreras/ingenieria-industrial-",
        #     "/grado/carreras/ingenieria-mecanica",
        #     "/grado/carreras/ingenieria-naval-y-mecanica-",
        #     "/grado/carreras/ingenieria-quimica",
        #     "/grado/carreras/lic-en-analisis-de-sistemas-"
        #   ]
        # ],
        ["/bienestar",
          [
            "/bienestar/articulacion-social",
            "/bienestar/becas",
            "/bienestar/cultura",
            "/bienestar/deportes",
            "/bienestar/derechos-humanos",
            "/bienestar/expo-fiuba-laboral",
            "/bienestar/idiomas",
            "/bienestar/inclusion-genero-y-diversidad",
            "/bienestar/insercion-laboral",
            "/bienestar/orientacion-vocacional-y-educativa-sove-"
          ]
        ]
     ]

    Enum.map(
      elementos,
      fn elemento ->

        id_pagina_principal = elemento |> Enum.at(0) |> traer_id_pagina()

        ids_elementos_grilla = Enum.map(
          elemento |> Enum.at(1),
          fn seo_url_grilla ->
            traer_id_navegacion(seo_url_grilla)
          end
        )
        actualizar_pagina(id_pagina_principal, ids_elementos_grilla)
      end
    )

  end

end
