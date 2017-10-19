defmodule ElixirAuthGithub do
  @moduledoc """
  ElixirAuthGithub is a module to help you with Github OAuth in Elixir and Phoenix.

  We created it because everyone at dwyl uses github (including our clients!) so github OAuth makes sense for our internal (and external) tools. As a result, there's no use reinventing the wheel every project, and by making it into a module we can help other people as well!

  First, add `:elixir_auth_github` to your deps in your mix.exs, then run `mix deps.get` in your terminal.

  ```elixir
  def deps do
    [
      {:elixir_auth_github, "~> 0.1.4"}
    ]
  end
  ```

  In order to set up Github OAuth in your app, you will first need to create an
  OAuth app on github, in here you'll give a callback URL. This will be a URL
  which github will redirect back to with a code for you to use to get a user's
  data from github. Something like `https://www.my-awesome-app.com/auth/gh-callback/`. The querystring with the code will be added to the end.

  Once you've set up your OAuth app on github can set up the variables in your config.exs.

  ```elixir
  config :elixir_auth_github,
    client_id: <YOUR-CLIENT-ID-HERE>,
    client_secret: <YOUR-CLIENT-SECRET-HERE>
  ```

  We would recommend using environment variables for your client_id and client_secret so that they're not free for everyone to see on github!

  You're now going to have to create a route in your app, it can be anything that you want, but you're then going to redirect your user to the value returned from `ElixirAuthGithub.login_url/0`.

  There is `login_url/0` for a standard url with only your client id, `login_url/1` to pass in some state as a string so that you can keep track
  of where the user was when they logged in. We also have
  `login_url_with_scope/1` for passing in a list of scopes (scopes are the
  permissions you will have on the user's account.), and
  `login_url_with_scope/2` for passing in a list of scopes, and state as a
  string. For more information about scopes in github OAuth take a look at
  [Github's own documentation](https://developer.github.com/apps/building-integrations/setting-up-and-registering-oauth-apps/about-scopes-for-oauth-apps/)

  You will also need a route in your app for the callback url you created earlier. It will come in with a querystring in the format of "code=1234". Pull the code off of this URL, and pass it into `&ElixirAuthGithub.github_auth/1`. This function will then do the needed calls to the github API, and then return your user's info from github along with the access token (for you to do whatever you want with!).

  If succesful it will return in the format of `{:ok, USER-INFO-MAP}`, if unsuccesful it will return `{:error, ERROR-INFO}`

  And there you have it! You still have to do a bit of set up, but we do the business end of the OAuth flow for you.
  """

  @github_auth_url "https://github.com/login/oauth/access_token?"
  @httpoison Application.get_env(:elixir_auth_github, :httpoison) || HTTPoison
  @valid_scopes [
    "user", "user:email", "user:follow", "public_repo", "repo",
    "repo_deployment", "repo:status", "repo:invite", "delete_repo",
    "notifications", "gist", "read:repo_hook", "write:repo_hook",
    "admin:org_hook", "read:org", "write:org", "admin:org", "read:public_key",
    "write:public_key", "admin:public_key", "read:gpg_key", "write:gpg_key",
    "admin:gpg_key"
  ]

  @doc """
  Returns a String URL to be used as the initial OAuth redirect.

  Requires `client_id` and `client_secret` environment variables to be set.
  """
  def login_url do
    case Application.get_env(:elixir_auth_github, :client_id) do
      nil ->
        "ENVIRONMENT VARIABLES NOT SET"
      client_id ->
        "https://github.com/login/oauth/authorize?client_id=#{client_id}"
    end
  end

  @doc """
  Identical to `login_url/0` except with an additional state property.
  """
  def login_url(state) do
    case login_url() do
      "ENVIRONMENT VARIABLES NOT SET" ->
        "ENVIRONMENT VARIABLES NOT SET"
      url ->
        url <> "&state=#{state}"
    end
  end

  @doc """
    takes a list of scopes to add to the url, will check that the scopes are
    valid, invalid scopes will be filtered out. Return value is in the format of
    {:ok, url} or {:err, reason}. Reasons this function can error are
    environment variables not being set, or no valid scopes being provided.
  """
  def login_url_with_scope(scopes) do
    case login_url() do
      "ENVIRONMENT VARIABLES NOT SET" ->
        {:err, "ENVIRONMENT VARIABLES NOT SET"}
      url ->
        case filter_valid_scopes(scopes) do
          {:ok, scopes} ->
            {:ok, url <> "&scope=#{Enum.join(scopes, "%20")}"}
          err ->
            err
        end
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
    Enum.filter(scopes,
                fn scope -> Enum.member? @valid_scopes, scope end)
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
