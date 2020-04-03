defmodule ElixirAuthGithub do
  @moduledoc """
  ElixirAuthGithub is an Elixir package that handles all your GitHub OAuth needs
  so you can add "Sign in with GitHub" to any Elixir/Phoenix App.

  For all setup details, please see: https://github.com/dwyl/elixir-auth-github
  """

  @github_url "https://github.com/login/oauth/"
  @github_auth_url @github_url <> "access_token?"

  @doc """
  `inject_poison/0` injects a TestDouble of HTTPoison in Test
  so that we don't have duplicate mock in consuming apps.
  see: https://github.com/dwyl/elixir-auth-google/issues/35
  """
  def inject_poison() do
    (Mix.env() == :test && ElixirAuthGithub.HTTPoisonMock) || HTTPoison
  end

  @doc """
  `login_url/0` returns a `String` URL to be used as the initial OAuth redirect.

  Requires `GITHUB_CLIENT_ID` environment variable to be set.
  See step 2 of setup instructions.
  """
  def login_url do
    client_id = System.get_env("GITHUB_CLIENT_ID")
    @github_url <> "authorize?client_id=#{client_id}"
  end

  @doc """
  Identical to `login_url/0` except with an additional state and scope properties
  appended to the URL.
  """
  def login_url(%{scopes: scopes, state: state}) do
    login_url() <>
      "&scope=#{Enum.join(scopes, "%20")}" <>
      "&state=#{state}"
  end

  def login_url(%{scopes: scopes}) do
    login_url() <> "&scope=#{Enum.join(scopes, "%20")}"
  end

  def login_url(%{state: state}) do
    login_url() <> "&state=#{state}"
  end

  @doc """
  When called with a valid OAuth callback code, `github_auth/1` makes a number of
  authentication requests to GitHub and returns a tuple with `:ok` and a map with
  GitHub user details and an access_token.

  Bad authentication codes will return a tuple with `:error` and an error map.
  """
  def github_auth(code) do
    query =
      URI.encode_query(%{
        "client_id" => System.get_env("GITHUB_CLIENT_ID"),
        "client_secret" => System.get_env("GITHUB_CLIENT_SECRET"),
        "code" => code
      })

    inject_poison().post!(@github_auth_url <> query, "")
    |> Map.get(:body)
    |> URI.decode_query()
    |> check_authenticated
  end

  defp check_authenticated(%{"access_token" => access_token}) do
    access_token
    |> get_user_details
  end

  defp check_authenticated(error), do: {:error, error}

  defp get_user_details(access_token) do
    inject_poison().get!("https://api.github.com/user", [
      #  https://developer.github.com/v3/#user-agent-required
      {"User-Agent", "ElixirAuthGithub"},
      {"Authorization", "token #{access_token}"}
    ])
    |> Map.get(:body)
    |> Poison.decode!()
    |> set_user_details(access_token)
  end

  defp set_user_details(%{"login" => _name} = user, access_token) do
    user = Map.put(user, "access_token", access_token)
    # transform map with keys as strings into keys as atoms!
    # https://stackoverflow.com/questions/31990134
    atom_key_map = for {key, val} <- user, into: %{}, do: {String.to_atom(key), val}
    {:ok, atom_key_map}
  end

  defp set_user_details(error, _token), do: {:error, error}
end
