use Mix.Config

config :elixir_auth_github,
  client_id: "d6fca75c63daa014c187",
  client_secret: "8eeb143935d1a505692aaef856db9b4da8245f3c",
  httpoison_mock: true

System.put_env(
  "GOOGLE_CLIENT_ID",
  "631770888008-6n0oruvsm16kbkqg6u76p5cv5kfkcekt.apps.googleusercontent.com"
)
