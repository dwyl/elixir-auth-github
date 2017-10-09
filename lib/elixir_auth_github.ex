defmodule ElixirAuthGithub do
  @moduledoc """
  Documentation for ElixirAuthGithub.
  """

  @github_auth_url "https://github.com/login/oauth/access_token?"
  @httpoison Application.get_env(:elixir_auth_github, :httpoison)

  def login_url do
    case Application.get_env(:elixir_auth_github, :client_id) do
      nil ->
        "ENVIRONMENT VARIABLES NOT SET"
      client_id ->
        "https://github.com/login/oauth/authorize?client_id=#{client_id}"
    end
  end

  def login_url(state) do
    case Application.get_env(:elixir_auth_github, :client_id) do
      nil ->
        "ENVIRONMENT VARIABLES NOT SET"
      client_id ->
        "https://github.com/login/oauth/authorize?client_id=#{client_id}&state=#{state}"
    end
  end

  def github_auth(code) do
    %{"client_id" => Application.get_env(:elixir_auth_github, :client_id),
      "client_secret" => Application.get_env(:elixir_auth_github, :client_secret),
      "code" => code}
    |> URI.encode_query
    |> (&(@httpoison.post!(@github_auth_url <> &1, ""))).()
    |> Map.get(:body)
    |> URI.decode_query
    |> check_authenticated
  end

  defp check_authenticated(%{"access_token" => access_token}) do
    access_token
    |> get_user_details
  end

  defp check_authenticated(error), do: {:error, error}


  defp get_user_details(access_token) do
    @httpoison.get!("https://api.github.com/user", [
      {"User-Agent", "elixir-practice"},
      {"Authorization", "token #{access_token}"}
    ])
    |> Map.get(:body)
    |> Poison.decode!
    |> set_user_details(access_token)
  end

  defp set_user_details(%{"login" => _name} = user, access_token) do
    user = Map.put(user, "access_token", access_token)

    {:ok, user}
  end

  defp set_user_details(error, _token), do: {:error, error}
end
