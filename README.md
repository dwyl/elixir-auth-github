# ElixirAuthGithub

![Build Status](https://img.shields.io/travis/com/dwyl/elixir-auth-github/master?color=bright-green&style=flat-square)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/elixir-auth-github/master.svg?style=flat-square)](http://codecov.io/github/dwyl/elixir-auth-github?branch=master)
![Hex.pm](https://img.shields.io/hexpm/v/elixir_auth_google?color=brightgreen&style=flat-square)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/elixir-auth-github/issues)
<!--
[![HitCount](http://hits.dwyl.io/dwyl/elixir-auth-github.svg)](http://hits.dwyl.io/dwyl/elixir-auth-github)
-->

ElixirAuthGithub is a module to help you with Github OAuth in Elixir and Phoenix.

[Check it out on hex.pm](https://hex.pm/packages/elixir_auth_github/0.1.0)

We created it because everyone at dwyl uses github (including our clients!) so github OAuth makes sense for our internal (and external) tools. As a result, there's no use reinventing the wheel every project, and by making it into a module we can help other people as well!

First, add `:elixir_auth_github` to your deps in your mix.exs, then run `mix deps.get` in your terminal.

```elixir
def deps do
  [
    {:elixir_auth_github, "~> 1.0.0"}
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

You're now going to have to create a route in your app, it can be anything that you want, but you're then going to redirect your user to the value returned from `&ElixirAuthGithub.login_url/0`. You can also use `&ElixirAuthGithub.login_url/1`, if you want to pass in some state as a string so that you can maintain some state through the login process.

You will also need a route in your app for the callback url you created earlier. It will come in with a querystring in the format of "code=1234". Pull the code off of this URL, and pass it into `&ElixirAuthGithub.github_auth/1`. This function will then do the needed calls to the github API, and then return your user's info from github along with the access token (for you to do whatever you want with!).

If succesful it will return in the format of `{:ok, USER-INFO-MAP}`, if unsuccesful it will return `{:error, ERROR-INFO}`

And there you have it! You still have to do a bit of set up, but we do the business end of the OAuth flow for you.
