defmodule ElixirAuthGithub.HTTPoison.HTTPoison do
  @moduledoc """
    Because we are mocking API requests in ElixirAuthGithub.HTTPoison.Stub
    we need this module to delegate to the actual HTTPoison module.
  """

  defdelegate get!(url, headers, options \\ []), to: HTTPoison

  defdelegate post!(url, body, headers \\ [], options \\ []), to: HTTPoison
end
