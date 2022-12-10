import Config

config :elixir_auth_github,
  httpoison_mock: false


if Mix.env() == :test do
  import_config "test.exs"
end
