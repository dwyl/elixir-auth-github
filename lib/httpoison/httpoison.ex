defmodule ElixirAuthGithub.HTTPoison.HTTPoison do
  import HTTPoison

  defdelegate get!(url, headers, options \\ []), to: HTTPoison

  defdelegate post!(url, body, headers \\ [], options \\ []), to: HTTPoison
end
