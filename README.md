# FiubaWebMigration

Importante:

  Hasta tener nix andando, verificar que el config/config.exs tenga la contraseña correcta

Para levantar la consola usar 

iex -S mix

Ejemplo para hacer una query en la consola:

alias FiubaWebMigration.Repo
import Ecto.Query
query = from data in "field_data_body",
	  select: [:body_value, :language],
          limit: 2
Repo.all(query)




Otras queries:

query = from node in "node",
	
	join: body in "field_data_body", 
	on: body.entity_id == node.nid,
    
	left_join: date in "field_data_field_date", 
	on: date.entity_id == node.nid,

	left_join: img_code in "field_data_field_image",
	on: img_code.entity_id == node.nid and img_code.bundle == "article",

	left_join: img_url in "file_managed",
	on: img_url.fid == img_code.field_image_fid,
	
	where: node.nid == 1247,
	
	select: [
		node.nid, 
		node.title, 
		date.field_date_value,
		img_url.uri,
		body.body_value
		],

	limit: 1

Repo.all(query)



Una forma de hacerlo sin pasarlo a Ecto_sql

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
LIMIT 2
")


