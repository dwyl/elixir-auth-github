defmodule ElixirAuthGithubTest do
  use ExUnit.Case
  doctest ElixirAuthGithub

  defp client_id do
    System.get_env("GITHUB_CLIENT_ID")
  end

  defp setup_test_environment_variables do
    System.put_env([{"GITHUB_CLIENT_ID", "TEST_ID"}, {"GITHUB_CLIENT_SECRET", "TEST_SECRET"}])
  end

  test "login_url/0 returns authorize URL with client_id appended" do
    assert ElixirAuthGithub.login_url() ==
             "https://github.com/login/oauth/authorize?client_id=" <> client_id()
  end

  test "login_url/1 with state returns authorize URL with client_id" do
    url =
      "https://github.com/login/oauth/authorize?client_id=" <>
        client_id() <> "&state=california"

    assert ElixirAuthGithub.login_url(%{state: "california"}) == url
  end

  test "test login_url_with_scope/1 with all valid scopes" do
    url =
      "https://github.com/login/oauth/authorize?client_id=" <>
        client_id() <> "&scope=user%20user:email"

    assert ElixirAuthGithub.login_url(%{scopes: ["user", "user:email"]}) == url
  end

  test "test login_url/1 with all valid scopes and state" do
    url =
      "https://github.com/login/oauth/authorize?client_id=" <>
        client_id() <> "&scope=user%20user:email" <> "&state=california"

    assert ElixirAuthGithub.login_url(%{scopes: ["user", "user:email"], state: "california"}) ==
             url
  end

  test "test login_url/1 with some invalid scopes (should be :ok)" do
    url =
      "https://github.com/login/oauth/authorize?client_id=" <>
        client_id() <> "&scope=user%20user:email"

    scopes = ["user", "user:email"]
    assert ElixirAuthGithub.login_url(%{scopes: scopes}) == url
  end

  test "github_auth returns a user and token" do
    setup_test_environment_variables()
    {:ok, res} = ElixirAuthGithub.github_auth("12345")
    assert res.login == "test_user"
    assert res.id == "19"
  end

  test "github_auth returns an error with a bad code" do
    setup_test_environment_variables()

    assert ElixirAuthGithub.github_auth("1234") ==
             {:error, %{"error" => "error"}}
  end

  test "github_auth returns an error with a bad code 123" do
    setup_test_environment_variables()
    res = ElixirAuthGithub.github_auth("123")
    assert res == {:error, %{"error" => "test error"}}
  end

  test "fetch primary email for user" do
    setup_test_environment_variables()
    {:ok, res} = ElixirAuthGithub.github_auth("42")
    assert res.email == "private_email@gmail.com"
  end
end
