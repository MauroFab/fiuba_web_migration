defmodule Migracion_paneles_y_menues do

  alias FiubaWebMigration.Repo
  import Ecto.Query
  import JSON
  import String
  import HTTPoison.Retry
  import Utils


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

  def actualizar_grilla_pagina(id_pagina, ids_navs_pag) do

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


  def traer_id_menu_lateral(navegacion_seo_url) do

    response_pagina = HTTPoison.get!("https://testing.cms.fiuba.lambdaclass.com/navegacion?seo_url=" <> navegacion_seo_url)

    response_body = response_pagina.body
    {:ok, response_body_map} = JSON.decode(response_body)
    {:ok, vinculo} = Map.fetch(response_body_map |> Enum.at(0), "vinculo")
    {:ok, pagina} = Map.fetch( vinculo |> Enum.at(0), "pagina")
    {:ok, id_menu_lateral} = Map.fetch( pagina, "menu_lateral")

    id_menu_lateral

  end


  def paneles() do


    # 447,Grado, /grado LISTO
    # 448,Posgrado, /podgrado LISTO
    # 452,Investigación, /investigacion LISTO
    # 453,Bienestar, /bienestar LISTO
    # 514,Institucional, /institucional LISTO
    # 2961,Decanato, /institucional/decanato LISTO
    # 656,Colección Biblioteca Ingeniería
    # 1282,Biblioteca, /biblioteca LISTO
    # 2473,English website LISTO
    # 2602,Graduados, /graduados LISTO
    # 2827,Revista .ing

    # 1712,Orientación Vocacional y Educativa (institucional/videoteca/inclusion, genero, bienestar y articulacion social / orientacion vocacional y educativa)
    # 3213,Orgullosamente FIUBA (graduados/Orgullosamente FIUBA, son video entrevistas NO
    # 685,Institucionales (institucional/videoteca/institucionales) NO
    # 726,Ciclo de ensayos (institucional/videoteca/ciclo de ensayor) NO
    # 727,Videoentrevistas (institucional/videoteca/videoentrevistas) NO
    # 888,Videoteca (institucional/videoteca) NO

    elementos =
      [
        ["/grado",
          [
            "/grado/carreras/ingenieria-civil",
            "/grado/carreras/ingenieria-de-alimentos",
            "/grado/carreras/ingenieria-electricista",
            "/grado/carreras/ingenieria-electronica",
            "/grado/carreras/ingenieria-en-agrimensura",
            "/grado/carreras/ingenieria-en-informatica",
            "/grado/carreras/ingenieria-en-petroleo",
            "/grado/carreras/ingenieria-industrial",
            "/grado/carreras/ingenieria-mecanica",
            "/grado/carreras/ingenieria-naval-y-mecanica",
            "/grado/carreras/ingenieria-quimica",
            "/grado/carreras/lic-en-analisis-de-sistemas"
          ]
        ],
        ["/grado/carreras",
          [
            "/grado/carreras/ingenieria-civil",
            "/grado/carreras/ingenieria-de-alimentos",
            "/grado/carreras/ingenieria-electricista",
            "/grado/carreras/ingenieria-electronica",
            "/grado/carreras/ingenieria-en-agrimensura",
            "/grado/carreras/ingenieria-en-informatica",
            "/grado/carreras/ingenieria-en-petroleo",
            "/grado/carreras/ingenieria-industrial",
            "/grado/carreras/ingenieria-mecanica",
            "/grado/carreras/ingenieria-naval-y-mecanica",
            "/grado/carreras/ingenieria-quimica",
            "/grado/carreras/lic-en-analisis-de-sistemas"
          ]
        ],
        ["/posgrado",
          [
            "/posgrado/maestrias",
            "/posgrado/maestrias/automatizacion-industrial",
            "/posgrado/maestrias/ciencias-de-la-ingenieria",
            "/posgrado/maestrias/construccion-y-diseno-estructural",
            "/posgrado/maestrias/direccion-industrial",
            "/posgrado/maestrias/diseno-abierto-para-la-innovacion",
            "/posgrado/maestrias/estudios-sobre-servicios-de-comunicacion-audiovisual",
            "/posgrado/maestrias/explotacion-de-datos-y-descubrimiento-de-conocimiento",
            "/posgrado/maestrias/ingenieria-de-materiales-compuestos",
            "/posgrado/maestrias/ingenieria-de-transporte--orientacion-vial",
            "/posgrado/maestrias/ingenieria-en-petroleo-y-gas-natural",
            "/posgrado/maestrias/ingenieria-en-telecomunicaciones",
            "/posgrado/maestrias/ingenieria-matematica",
            "/posgrado/maestrias/ingenieria-optoelectronica-y-fotonica",
            "/posgrado/maestrias/ingenieria-sanitaria",
            # "/posgrado/maestrias/internet-de-las-cosas", #ESTE NO ESTA
            "/posgrado/maestrias/planificacion-y-gestion-de-la-ingenieria-urbana",
            "/posgrado/maestrias/planificacion-y-gestion-del-transporte",
            "/posgrado/maestrias/planificacion-y-movilidad-urbana",
            "/posgrado/maestrias/seguridad-informatica",
            "/posgrado/maestrias/servicios-y-redes-de-telecomunicaciones",
            "/posgrado/maestrias/simulacion-numerica-y-control",
            "/posgrado/maestrias/sistemas-embebidos",
            "/posgrado/maestrias/tecnologias-urbanas-sostenibles",
            "/posgrado/carreras-de-especializacion",
            "/posgrado/carreras-de-especializacion/automatizacion-industrial",
            "/posgrado/carreras-de-especializacion/explotacion-de-datos-y-descubrimiento-de-conocimiento",
            "/posgrado/carreras-de-especializacion/gas-natural",
            "/posgrado/carreras-de-especializacion/gestion-de-servicios",
            "/posgrado/carreras-de-especializacion/higiene-y-seguridad-en-el-trabajo",
            "/posgrado/carreras-de-especializacion/ingenieria-de-reservorios",
            "/posgrado/carreras-de-especializacion/ingenieria-ferroviaria",
            "/posgrado/carreras-de-especializacion/ingenieria-geodesicageofisica",
            "/posgrado/carreras-de-especializacion/ingenieria-optoelectronica",
            "/posgrado/carreras-de-especializacion/ingenieria-portuaria",
            "/posgrado/carreras-de-especializacion/ingenieria-sanitaria",
            # "/posgrado/carreras-de-especializacion/internet-de-las-cosas", # NO ESTA
            "/posgrado/carreras-de-especializacion/petroleo-y-derivados",
            "/posgrado/carreras-de-especializacion/proteccion-radiologica-y-seguridad-de-las-fuentes-de-radiacion",
            "/posgrado/carreras-de-especializacion/seguridad-informatica",
            "/posgrado/carreras-de-especializacion/seguridad-nuclear",
            "/posgrado/carreras-de-especializacion/servicios-y-redes-de-telecomunicaciones",
            "/posgrado/carreras-de-especializacion/sistemas-embebidos",
            "/posgrado/carreras-de-especializacion/tecnologia-de-telecomunicaciones",
            "/posgrado/carreras-de-especializacion/tecnologias-urbanas-sostenibles",
            "/posgrado/cursos-anuales-y-bianuales",
            "/posgrado/cursos-anuales-y-bianuales/geociencias-aplicadas-a-la-exploracion-y-desarrollo-de-los-hidrocarburos",
            "/posgrado/doctorado"
          ]
        ],
        ["/investigacion",
          [
            "/investigacion/areas-de-investigacion/ambiente",
            "/investigacion/areas-de-investigacion/arqueometria",
            "/investigacion/areas-de-investigacion/bioingenieria",
            "/investigacion/areas-de-investigacion/bioprinting",
            "/investigacion/areas-de-investigacion/comunicaciones",
            "/investigacion/areas-de-investigacion/diseno-y-desarrollo-de-productos",
            "/investigacion/areas-de-investigacion/electronica",
            "/investigacion/areas-de-investigacion/energia",
            "/investigacion/areas-de-investigacion/ensenanza",
            "/investigacion/areas-de-investigacion/fluidos",
            "/investigacion/areas-de-investigacion/geodesiageofisica",
            "/investigacion/areas-de-investigacion/hidrodinamica-naval",
            "/investigacion/areas-de-investigacion/hidrologiahidraulica",
            "/investigacion/areas-de-investigacion/informatica",
            "/investigacion/areas-de-investigacion/matematica-aplicada",
            "/investigacion/areas-de-investigacion/materiales-y-estructuras-para-ingenieria-civil",
            "/investigacion/areas-de-investigacion/materiales-y-nanotecnologia",
            "/investigacion/areas-de-investigacion/mecanica-y-robotica",
            "/investigacion/areas-de-investigacion/medicion-y-control",
            "/investigacion/areas-de-investigacion/metodos-y-modelos-aplicados-a-la-gestion",
            "/investigacion/areas-de-investigacion/optica-y-laser",
            "/investigacion/areas-de-investigacion/procesos-quimicos",
            "/investigacion/areas-de-investigacion/quimica",
            "/investigacion/areas-de-investigacion/tecnologia-de-alimentos"
          ]
        ],
        ["/investigacion/areas-de-investigacion",
          [
            "/investigacion/areas-de-investigacion/ambiente",
            "/investigacion/areas-de-investigacion/arqueometria",
            "/investigacion/areas-de-investigacion/bioingenieria",
            "/investigacion/areas-de-investigacion/bioprinting",
            "/investigacion/areas-de-investigacion/comunicaciones",
            "/investigacion/areas-de-investigacion/diseno-y-desarrollo-de-productos",
            "/investigacion/areas-de-investigacion/electronica",
            "/investigacion/areas-de-investigacion/energia",
            "/investigacion/areas-de-investigacion/ensenanza",
            "/investigacion/areas-de-investigacion/fluidos",
            "/investigacion/areas-de-investigacion/geodesiageofisica",
            "/investigacion/areas-de-investigacion/hidrodinamica-naval",
            "/investigacion/areas-de-investigacion/hidrologiahidraulica",
            "/investigacion/areas-de-investigacion/informatica",
            "/investigacion/areas-de-investigacion/matematica-aplicada",
            "/investigacion/areas-de-investigacion/materiales-y-estructuras-para-ingenieria-civil",
            "/investigacion/areas-de-investigacion/materiales-y-nanotecnologia",
            "/investigacion/areas-de-investigacion/mecanica-y-robotica",
            "/investigacion/areas-de-investigacion/medicion-y-control",
            "/investigacion/areas-de-investigacion/metodos-y-modelos-aplicados-a-la-gestion",
            "/investigacion/areas-de-investigacion/optica-y-laser",
            "/investigacion/areas-de-investigacion/procesos-quimicos",
            "/investigacion/areas-de-investigacion/quimica",
            "/investigacion/areas-de-investigacion/tecnologia-de-alimentos"
          ]
        ],
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
            "/bienestar/orientacion-vocacional-y-educativa-sove"
          ]
        ],
        ["/institucional",
          [
            "/institucional/sedes/paseo-colon",
            "/institucional/sedes/las-heras",
            "/institucional/sedes/ciudad-universitaria"
          ]
        ],
        ["/institucional/sedes",
          [
            "/institucional/sedes/paseo-colon",
            "/institucional/sedes/las-heras",
            "/institucional/sedes/ciudad-universitaria"
          ]
        ],
        ["/institucional/decanato",
          [
            "/institucional/decanato/decano",
            "/institucional/decanato/vicedecano"
          ]
        ],
        ["/institucional/coleccion-biblioteca-ingenieria",
          [
            "/institucional/coleccion-biblioteca-ingenieria/coleccion-biblioteca-ingenieria/ampliaciones-en-infraestructura-de-transporte-de-energia-electrica",
            "/institucional/coleccion-biblioteca-ingenieria/coleccion-biblioteca-ingenieria/asignacion-de-derechos-de-propiedad-sobre-la-transmision-de-energia-electrica",
            "/institucional/coleccion-biblioteca-ingenieria/coleccion-biblioteca-ingenieria/azar-ciencia-y-sociedad",
            "/institucional/coleccion-biblioteca-ingenieria/coleccion-biblioteca-ingenieria/biomecanica-y-modelizacion-en-mecanobiologia",
            "/institucional/coleccion-biblioteca-ingenieria/coleccion-biblioteca-ingenieria/ingenieria-de-cables-aislados-para-transmision-de-energia-electrica",
            "/institucional/coleccion-biblioteca-ingenieria/coleccion-biblioteca-ingenieria/ingenieria-electromagnetica",
            "/institucional/coleccion-biblioteca-ingenieria/coleccion-biblioteca-ingenieria/ingles-en-ciencias-e-ingenieria",
            "/institucional/coleccion-biblioteca-ingenieria/coleccion-biblioteca-ingenieria/introduccion-a-la-filosofia-de-la-ciencia-y-la-tecnologia",
            "/institucional/coleccion-biblioteca-ingenieria/coleccion-biblioteca-ingenieria/java",
            "/institucional/coleccion-biblioteca-ingenieria/coleccion-biblioteca-ingenieria/matematica-de-pregrado-para-ingenieria"
          ]
        ],
        ["/biblioteca",
          [
            "/biblioteca/informacion-general",
            "/biblioteca/biblioteca-digital",
            "/biblioteca/servicios",
            "/biblioteca/catalogo"
          ]
        ],
        ["/extranjeros/english-website",
          [
            "/extranjeros/english-website/institutional",
            "/extranjeros/english-website/undergraduate",
            "/extranjeros/english-website/posgraduate",
            "/extranjeros/english-website/doctorate"
          ]
        ],
        ["/graduados",
          [
            "/graduados/bodas-con-la-profesion",
            "/graduados/bolsa-de-trabajo",
            "/graduados/padron-de-graduados",
            "/graduados/departamentos-y-comisiones-curriculares"
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
        actualizar_grilla_pagina(id_pagina_principal, ids_elementos_grilla)
      end
    )

  end


  def menues_laterales() do

    elementos =
      [

        [ "/institucional",
          [
            "/institucional/sedes",
            "/institucional/vision-mision-y-funciones",
            "/institucional/historia",
            "/institucional/consejo-directivo",
            "/institucional/decanato",
            "/institucional/secretarias",
            "/institucional/departamentos",
            "/institucional/institutos-centros-y-escuelas",
            "/institucional/consulta-de-resoluciones",
            "/institucional/consulta-de-expedientes",
            # "/institucional/videoteca",
            "/institucional/comunicacion-institucional",
            "/institucional/coleccion-biblioteca-ingenieria",
            "/institucional/ceremonial",
            "/institucional/nueva-guia-de-internos"
          ]
        ],
        [
          "/grado",
          [
            "/grado/carreras",
            "/grado/por-que-la-uba",
            "/grado/visitas-guiadas"
          ]
        ],
        [
          "/posgrado",
          [
            "/posgrado/maestrias",
            "/posgrado/carreras-de-especializacion",
            "/posgrado/cursos-anuales-y-bianuales",
            "/posgrado/cursos-de-complementacion-y-formacion-continua",
            "/posgrado/cursos-a-empresas-e-instituciones",
            "/posgrado/destinatarios",
            "/posgrado/estudiantes-extranjeros",
            "/posgrado/tipos-de-posgrado",
            "/posgrado/beneficios-comunidad-fiuba",
            "/posgrado/solicitud-de-certificados-y-diplomas",
            "/posgrado/maestrias-internacionales",
            "/posgrado/posgrados-en-ingenieria",
            "/posgrado/doctorado",
            "/posgrado/english-website",
            "/posgrado/contacto"
          ]
        ],
        [
          "/investigacion",
          [
            "/investigacion/mision",
            "/investigacion/areas-de-investigacion",
            "/investigacion/relaciones-internacionales",
            "/investigacion/doctorado",
            "/investigacion/becas",
            "/investigacion/maestrias",
            "/investigacion/para-investigadores",
            "/investigacion/subsidios",
            "/investigacion/boletin-digital",
            "/investigacion/doctorado"
          ]
        ],
        [
          "/bienestar",
          [
            "/bienestar/articulacion-social",
            "/bienestar/becas",
            "/bienestar/areas",
            "/bienestar/cultura",
            "/bienestar/deportes",
            "/bienestar/derechos-humanos",
            "/bienestar/expo-fiuba-laboral",
            "/bienestar/inclusion-genero-y-diversidad",
            "/bienestar/idiomas",
            "/bienestar/insercion-laboral",
            "/bienestar/orientacion-vocacional-y-educativa-sove",
            "/bienestar/contacto"
          ]
        ],
        [
          "/extranjeros/english-website",
          [
            "/extranjeros/english-website/institutional",
            "/extranjeros/english-website/undergraduate",
            "/extranjeros/english-website/posgraduate",
            "/extranjeros/english-website/doctorate"
          ]
        ],
        [ "/biblioteca",
          [
            "/biblioteca/novedades",
            "/biblioteca/donaciones",
            "/biblioteca/formacion-y-ayuda",
            "/biblioteca/sedes-y-horarios",
            "/biblioteca/contactos",
            "/biblioteca/fotogaleria",
            "/biblioteca/buzon-de-sugerencias",
            "/biblioteca/consulte-al-bibliotecario"
          ]
        ],
        # [
        #  "/transparencia",
        #   [
        #    "/transparencia/biblioteca",
        #    "/transparencia/bolsa-de-trabajo",
        #    "/institucional/secretarias/secretaria-administrativa/direccion-general-de-recursos-fisicos-y-financieros/direccion-de-compras-y-contrataciones",
        #    "/bienestar/derechos-humanos",
        #    "/noticias",
        #    "/prensa",
        #    "/institucional/secretarias/secretaria-de-relaciones-institucionales/convenios-y-trabajos-a-terceros",
        #    "/grado/visitas-guiadas",
        #    "/transparencia"
        #   ]
        # ]
      ]

    Enum.map(
      elementos,
      fn elemento ->

        id_menu_lateral = elemento |> Enum.at(0) |> traer_id_menu_lateral()

        ids_navs = Enum.map(
          elemento |> Enum.at(1),
          fn seo_url_grilla ->
            traer_id_navegacion(seo_url_grilla)
          end
        )
        actualizar_menu_lateral(id_menu_lateral, ids_navs)
      end
    )

  end

end
