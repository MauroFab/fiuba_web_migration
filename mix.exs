defmodule FiubaWebMigration.MixProject do
  use Mix.Project

  def project do
    [
      app: :fiuba_web_migration,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {FiubaWebMigration.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:myxql, "~> 0.5.0"},
      {:httpoison, "~> 1.8"},
      {:json, "~> 1.4.1"},
      {:html_sanitize_ex, "~> 1.4"},
      {:timex, "~> 3.0"},
      {:httpoison_retry, "~> 1.0.0"},
      {:panpipe, "~> 0.1.1"}
    ]
  end
end
