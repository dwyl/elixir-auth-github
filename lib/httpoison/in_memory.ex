defmodule ElixirAuthGithub.HTTPoison.InMemory do
  import HTTPoison

  def get!(_url, _headers \\ [], _options \\ []) do
    %{body: "{\"key\": \"value\"}"}
  end

  def post!(_url, _body, _headers \\ [], _options \\ []) do
    %{body: "access_token=HELLO"}
  end
end
