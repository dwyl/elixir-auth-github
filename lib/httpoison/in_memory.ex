defmodule ElixirAuthGithub.HTTPoison.InMemory do
  def get!(url, headers \\ [], options \\ [])
  def get!("https://api.github.com/user", [
    {"User-Agent", "elixir-practice"},
    {"Authorization", "token 123"}
  ], _options) do
    %{body: "{\"error\": \"test error\"}"}
  end

  def get!(_url, _headers, _options) do
    %{body: "{\"login\": \"test_user\"}"}
  end

  def post!(url, body, headers \\ [], options \\ [])
  def post!("https://github.com/login/oauth/access_token?client_id=TEST_ID&client_secret=TEST_SECRET&code=1234", _body, _headers, _options) do
    %{body: "error=error"}
  end

  def post!("https://github.com/login/oauth/access_token?client_id=TEST_ID&client_secret=TEST_SECRET&code=123", _body, _headers, _options) do
    %{body: "access_token=123"}
  end

  def post!(_url, _body, _headers, _options) do
    %{body: "access_token=12345"}
  end
end
