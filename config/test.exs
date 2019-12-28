use Mix.Config

# Stub all requests HTTP requests to GitHub API with known responses:
config :elixir_auth_github, :httpoison, ElixirAuthGithub.HTTPoison.Stub
