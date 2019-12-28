defmodule ElixirAuthGithub.HTTPoison.HTTPoison do
  @moduledoc """
    Because we are mocking API requests in ElixirAuthGithub.HTTPoison.St
    we have to have a separate module to delegate the functions we use
    to the actual HTTPoison module, so that's all we do here.
  """

  defdelegate get!(url, headers, options \\ []), to: HTTPoison

  defdelegate post!(url, body, headers \\ [], options \\ []), to: HTTPoison
end
