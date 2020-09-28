defmodule ElixirAuthGithub.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_auth_github,
      version: "1.4.1",
      elixir: "~> 1.10",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      start_permanent: Mix.env() == :prod,
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
      {:httpoison, "~> 1.7.0"},
      {:poison, "~> 4.0.1"},

      # tracking test coverage
      {:excoveralls, "~> 0.13.0", only: [:test, :dev]},

      # documentation
      {:ex_doc, "~> 0.22.6", only: :dev}
    ]
  end

  defp description() do
    "The simple way to add GitHub OAuth to your Elixir/Phoenix Apps!"
  end

  defp package() do
    [
      files: ~w(lib LICENSE mix.exs README.md .formatter.exs),
      links: %{"GitHub" => "https://github.com/dwyl/elixir-auth-github"},
      licenses: ["GNU GPL v2.0"],
      maintainers: ["dwyl & friends!"]
    ]
  end
end
