<div align="center">

# `elixir-auth-github`

The _easiest_ way to add GitHub OAuth authentication
to your Elixir/Phoenix Apps.

![Build Status](https://img.shields.io/travis/com/dwyl/elixir-auth-github/master?color=bright-green&style=flat-square)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/elixir-auth-github/master.svg?style=flat-square)](http://codecov.io/github/dwyl/elixir-auth-github?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/elixir_auth_github?color=brightgreen&style=flat-square)](https://hex.pm/packages/elixir_auth_github)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/elixir-auth-github/issues)
<!--
[![HitCount](http://hits.dwyl.io/dwyl/elixir-auth-github.svg)](http://hits.dwyl.io/dwyl/elixir-auth-github)
-->

</div>


# _Why_? 🤷

We needed a **_much_ simpler**
and **_extensively_ documented** way
to add "_**Sign-in** with **GitHub**_"
capability to our Elixir App(s). <br />

> We created this package
because everyone [@dwyl](https://github.com/dwyl)
uses GitHub so using GitHub OAuth makes sense
for our internal (and external) tools.
By making it into a well-documented and tested
reusable module other people can benefit from it.

# _What_? 💭


An Elixir package that seamlessly handles
GitHub OAuth Authentication/Authorization
in as few steps as possible. <br />
Following best practices for security & privacy
and avoiding complexity
by having sensible defaults for all settings.


# _Who_? 👥

This module is for people building apps using Elixir/Phoenix
who want to ship the "Sign-in with GitHub" feature _faster_
and more maintainably.

It's targetted at _complete_ beginners
with no prior experience/knowledge
of auth "schemes" or "strategies". <br />
Just follow the detailed instructions
and you'll be up-and running in 5 minutes.


# _How_? 💻

Add GitHub Auth to your Elixir/Phoenix project
by following these 5 simple steps:


## 1. Add the hex package to `deps` 📦

Open your project's **`mix.exs`** file
and locate the **`deps`** (dependencies) section. <br />
Add a line for **`:elixir_auth_github`** in the **`deps`** list:

```elixir
def deps do
  [
    {:elixir_auth_github, "~> 1.0.0"}
  ]
end
```

Once you have added the line to your **`mix.exs`**,
remember to run the **`mix deps.get`** command
in your terminal
to _download_ the dependencies.


## 2. Create a GitHub App and OAuth2 Credentials 🆕

Create a GitHub Application if you don't already have one,
generate the OAuth2 Credentials for the application
and save the credentials as environment variables
accessible by your app.

> **Note**: There are a few steps
for creating a set of GitHub APIs credentials,
so if you don't already have a GitHub App,
we created the following step-by-step guide
to make it quick and _relatively_ painless:
[create-github-app-guide.md](https://github.com/dwyl/elixir-auth-github/blob/master/create-github-app-guide.md) <br />
Don't be intimidated by all the buzz-words;
it's quite straightforward.
And if you get stuck,
[ask for help!](https://github.com/dwyl/elixir-auth-github/issues)


By the end of this step
you should have these two environment variables set:

```yml
GITHUB_CLIENT_ID=d6fca75c63daa014c187
GITHUB_CLIENT_SECRET=8eeb143935d1a505692aaef856db9b4da8245f3c
```

> ⚠️ Don't worry, these keys aren't valid
(_they were revoked **`before`** we published this guide_).
They are just here for illustration purposes.


> 💡 Tip: We tend to use an
[`.env`](https://github.com/dwyl/learn-environment-variables#3-use-a-env-file-locally-which-you-can-gitignore)
file to manage our environment variables on our `localhost`
and then use whichever system for environment variables appropriate
for our deployment.
e.g: [Heroku](https://github.com/dwyl/learn-environment-variables#environment-variables-on-heroku)
For an example `.env` file with the environment variables
required by `elixir-auth-github` see:
[`.env_sample`](https://github.com/dwyl/elixir-auth-github/blob/master/.env_sample)



## 3. Create 2 New Files  ➕

Create two files in order to handle the requests
to the GitHub OAuth API and display data to people using your app.

### 3.1 Create a `GithubAuthController` in your Project

In order to process and _display_ the data
returned by the GitHub OAuth2 API,
we need to create a new `controller`.

Create a new file called
`lib/app_web/controllers/github_auth_controller.ex`









<br />

## Useful Links and Further Reading

+ GitHub Apps docs:
https://developer.github.com/apps/building-github-apps/creating-a-github-app
+ Authorizing OAuth Apps:
https://developer.github.com/apps/building-oauth-apps/authorizing-oauth-apps
+ Basics of Authentication:
https://developer.github.com/v3/guides/basics-of-authentication/
+ GitHub Logos and Usage: https://github.com/logos <br />
(_tldr: no official auth buttons but use of Octocat logo is encouraged
to help users identify that your App has a GitHub integration_)

<br /><br /><br /><hr />

# SUPERSEDED



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
