# defmodule ElixirAuthGithub.HTTPoison.InMemory do
#   @moduledoc """
#   In-memory storage for data while it's being processed.
#   Because we are mocking the api requests in ElixirAuthGithub.HTTPoison.InMemory
#   we have a separate module to delegate the functions we use to the actual
#   HTTPoison module, so that's all we do here.
#   Note: if you have a suggestion of a better way to do this, please share!
#   """
#
#   defdelegate get!(url, headers, options \\ []), to: HTTPoison
#
#   defdelegate post!(url, body, headers \\ [], options \\ []), to: HTTPoison
# end
