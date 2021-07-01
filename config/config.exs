import Config

config :fiuba_web_migration, FiubaWebMigration.Repo,
  database: "drupaldb",
  username: "root",
  password: "fiubamli",
  hostname: "localhost",
  url_fiuba: "http://fi.uba.ar",
  url_strapi: "https://testing.cms.fiuba.lambdaclass.com/"

config :fiuba_web_migration, ecto_repos: [FiubaWebMigration.Repo]
