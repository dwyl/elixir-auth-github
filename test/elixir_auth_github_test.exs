defmodule ElixirAuthGithubTest do
  use ExUnit.Case
  doctest ElixirAuthGithub

  test "login_url returns an error without environment vars" do
    Application.put_env :elixir_auth_github, :client_id, nil
    assert ElixirAuthGithub.login_url() == "ENVIRONMENT VARIABLES NOT SET"
  end

  test "login_url returns the correct url when environment vars are set" do
    Application.put_env(:elixir_auth_github, :client_id, "TEST_ID")
    Application.get_env(:elixir_auth_github, :client_id)

    assert ElixirAuthGithub.login_url() == "https://github.com/login/oauth/authorize?client_id=TEST_ID"
  end

  test "login_url with state returns an error without environment vars" do
    Application.put_env :elixir_auth_github, :client_id, nil
    assert ElixirAuthGithub.login_url("hiya") == "ENVIRONMENT VARIABLES NOT SET"
  end

  test "login_url with state returns the correct url when environment vars are set" do
    Application.put_env :elixir_auth_github, :client_id, "TEST_ID"

    assert ElixirAuthGithub.login_url("hiya") == "https://github.com/login/oauth/authorize?client_id=TEST_ID&state=hiya"
  end

  test "github_auth returns a user and token" do
    Application.put_env :elixir_auth_github, :client_id, "TEST_ID"
    Application.put_env :elixir_auth_github, :client_secret, "TEST_SECRET"

    assert ElixirAuthGithub.github_auth("12345") == {:ok, %{"access_token" => "12345", "login" => "test_user"}}
  end

  test "github_auth returns an error with a bad code" do
    Application.put_env :elixir_auth_github, :client_id, "TEST_ID"
    Application.put_env :elixir_auth_github, :client_secret, "TEST_SECRET"

    assert ElixirAuthGithub.github_auth("1234") == {:error, %{"error" => "error"}}
  end

  test "test" do
    Application.put_env :elixir_auth_github, :client_id, "TEST_ID"
    Application.put_env :elixir_auth_github, :client_secret, "TEST_SECRET"

    assert ElixirAuthGithub.github_auth("123") == {:error, %{"error" => "test error"}}
  end

  test "Test github auth with state" do
    Application.put_env :elixir_auth_github, :client_id, "TEST_ID"
    Application.put_env :elixir_auth_github, :client_secret, "TEST_SECRET"

    assert ElixirAuthGithub.github_auth("12345", "hello") == {:ok, %{"access_token" => "12345", "login" => "test_user", "state" => "hello"}}
  end

  test "test github auth failure with state" do
    Application.put_env :elixir_auth_github, :client_id, "TEST_ID"
    Application.put_env :elixir_auth_github, :client_secret, "TEST_SECRET"

    assert ElixirAuthGithub.github_auth("1234", "hello") == {:error, %{"error" => "error"}}
  end

end