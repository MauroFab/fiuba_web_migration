# FiubaWebMigration

Importante:

  Hasta tener nix andando, verificar que el config/config.exs tenga la contraseña correcta

Para levantar la consola usar 

	iex -S mix

Para restaurar la BDD:

	mysql drupaldb -U root -p < bk_20210610.sql
	
El parametro -p indica que se va a completar con una contraseña, de no existir, no usar.


MENU_LINKS
plid = 0 and router_path = 'node/%'