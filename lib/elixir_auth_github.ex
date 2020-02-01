defmodule ElixirAuthGithub do
  @moduledoc """
  ElixirAuthGithub is an Elixir package that handles all your GitHub OAuth needs
  so you can add "Sign in with GitHub" to any Elixir/Phoenix App.

  For all setup details, please see: https://github.com/dwyl/elixir-auth-github
  """

  @github_url "https://github.com/login/oauth/"
  @github_auth_url @github_url <> "access_token?"
  @httpoison Application.get_env(:elixir_auth_github, :httpoison) || HTTPoison
  @valid_scopes [
    "user", "user:email", "user:follow", "public_repo",
    "repo_deployment", "repo:status", "repo:invite",
    "notifications", "gist", "read:repo_hook", "write:repo_hook",
    "admin:org_hook", "read:org",
    # The following scopes are considered potential security issues
    # because they allow *admin* access to repos, orgs or RSA keys:
    # "repo", "delete_repo", "write:org", "admin:org", "read:public_key",
    # "write:public_key", "admin:public_key", "read:gpg_key", "write:gpg_key",
    # "admin:gpg_key"
    # if you need these scopes or any others please see: https://git.io/JeNCQ
  ]

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
  Identical to `login_url/0` except with an additional state property
  appended to the url.
  """
  def login_url(state) do
    login_url()  <> "&state=#{state}"
  end

  @doc """
    takes a list of scopes to add to the url, will check that the scopes are
    valid, invalid scopes will be filtered out. Return value is in the format of
    {:ok, url} or {:err, reason}. Reasons this function can error are
    environment variables not being set, or no valid scopes being provided.
  """
  def login_url_with_scope(scopes) do
    url = login_url()
    # IO.inspect(scopes)
    case filter_valid_scopes(scopes) do
      {:ok, scopes} ->
        {:ok, url <> "&scope=#{Enum.join(scopes, "%20")}"}
      err ->
        err
    end
  end

  @doc """
    Does the same as login_url_with_scope/1 but adds state onto the end as well.
    Returns value in the format of {:err, reason} or {:ok, url}
  """
  def login_url_with_scope(scopes, state) do
    case login_url_with_scope(scopes) do
      {:ok, url} ->
        {:ok, url <> "&state=#{state}"}
      err ->
        err
    end
  end

  defp filter_valid_scopes(scopes) do
    Enum.filter(scopes, fn scope -> Enum.member? @valid_scopes, scope end)
    |> case do
      [] ->
        {:err, "no valid scopes provided"}
      scopes ->
        {:ok, scopes}
    end
  end


  @doc """
  When called with a valid OAuth callback code, `github_auth/1` makes a number of
  authentication requests to GitHub and returns a tuple with `:ok` and a map with
  GitHub user details and an access_token.

  Bad authentication codes will return a tuple with `:error` and an error map.
  """
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

  @doc """
  Same as `github_auth/1` except it adds the state String returned from GitHub.
  """
  def github_auth(code, state) do
    case github_auth(code) do
      {:ok, user} ->
        {:ok, Map.put(user, "state", state)}
      error ->
        error
    end
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
