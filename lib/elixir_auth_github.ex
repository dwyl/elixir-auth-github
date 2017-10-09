defmodule ElixirAuthGithub do
  @moduledoc """
  Documentation for ElixirAuthGithub.
  """

  @client_id Application.get_env(:elixir_auth_github, :client_id)
  @client_secret Application.get_env(:elixir_auth_github, :client_secret)
  @github_auth_url "https://github.com/login/oauth/access_token?"
  @httpoison Application.get_env(:elixir_auth_github, :httpoison)

  def login_url do
    case @client_id do
      nil ->
        IO.puts "ENVIRONMENT VARIABLES NOT SET"
      _ ->
        "https://github.com/login/oauth/authorize?client_id=#{@client_id}"
    end
  end

  def login_url(state) do
    case @client_id do
      nil ->
        IO.puts "ENVIRONMENT VARIABLES NOT SET"
      _ ->
        "https://github.com/login/oauth/authorize?client_id=#{@client_id}&state=#{state}"
    end
  end

  def github_auth(code) do
    %{"client_id" => @client_id,
      "client_secret" => @client_secret,
      "code" => code}
    |> URI.encode_query
    |> (&(@httpoison.post!(@github_auth_url <> &1, ""))).()
    |> Map.get(:body)
    |> URI.decode_query
    |> check_authenticated
  end

  def check_authenticated(%{"access_token" => access_token}) do
    access_token
    |> get_user_details
  end

  def check_authenticated(error), do: {:error, error}


  def get_user_details(access_token) do
    @httpoison.get!("https://api.github.com/user", [
      {"User-Agent", "elixir-practice"},
      {"Authorization", "token #{access_token}"}
    ])
    |> Map.get(:body)
    |> Poison.decode!
    |> set_user_details(access_token)
  end

  def set_user_details(%{"login" => name} = user, access_token) do
    user = Map.put(user, "access_token", access_token)

    {:ok, user}
  end

  def set_user_details(error), do: {:error, error}
end
