import Config

config :fiuba_web_migration, FiubaWebMigration.Repo,
  database: "drupaldb",
  username: "root",
  password: "fiubamli",
  hostname: "localhost"

config :fiuba_web_migration, ecto_repos: [FiubaWebMigration.Repo]
