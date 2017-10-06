defmodule ElixirAuthGithub do
  @moduledoc """
  Documentation for ElixirAuthGithub.
  """

  @client_id Application.get_env(:elixir_auth_github, :client_id)
  @client_secret Application.get_env(:elixir_auth_github, :client_secret)

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
    url = "https://github.com/login/oauth/access_token?"
    queryParams =
      URI.encode_query(%{"client_id" => @client_id,
                         "client_secret" => @client_secret,
                         "code" => code})

    %{body: accessQuery} =
      HTTPoison.post!(url <> queryParams, "")

    %{"access_token" => access_token} =
      URI.decode_query(accessQuery)
  end

  def get_user_details(access_token) do
    HTTPoison.get!("https://api.github.com/user", [
      {"User-Agent", "elixir-practice"},
      {"Authorization", "token #{access_token}"}
    ])
    |> IO.inspect
  end

end
