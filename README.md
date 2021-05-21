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

