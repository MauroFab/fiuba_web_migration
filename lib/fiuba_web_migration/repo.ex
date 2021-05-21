defmodule FiubaWebMigration.Repo do
  use Ecto.Repo,
    otp_app: :fiuba_web_migration,
    adapter: Ecto.Adapters.MyXQL
end
