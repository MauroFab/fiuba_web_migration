defmodule Prueba do
  alias FiubaWebMigration.Repo

  def prueba do
    variable = Application.get_env(:fiuba_web_migration_utils, :url_fiuba)
    IO.puts(variable)
  end
end
