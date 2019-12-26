defmodule ElixirAuthGithub.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_auth_github,
      version: "0.1.4",
      elixir: "~> 1.4",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test,
                         "coveralls.post": :test, "coveralls.html": :test],
      start_permanent: Mix.env == :prod,
      deps: deps(),
      name: "ElixirAuthGithub",
      source_url: "https://www.github.com/dwyl/elixir-auth-github",
      description: description(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:excoveralls, "~> 0.6", only: :test},
      {:ex_doc, "~> 0.13", only: :dev},
      {:pre_commit, "~> 0.1.3", only: :dev}
    ]
  end

  defp description() do
   "A module to help simplify github oauth in elixir/phoenix."
 end

  defp package() do
    [
      files: ["lib/elixir_auth_github.ex", "lib/httpoison/httpoison.ex", "mix.exs", "README.md", "LICENSE*"],
      links: %{"GitHub" => "https://github.com/dwyl/elixir-auth-github"},
      licenses: ["GNU GPL v2.0"],
      maintainers: ["Zooey Miller", "Finn Hodgkin"]
    ]
  end
end
