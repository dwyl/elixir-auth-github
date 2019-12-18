# Steps to Register a new GitHub Application

This guide is _based_ on the _official_ "Creating a GitHub App" instructions:
https://developer.github.com/apps/building-github-apps/creating-a-github-app
We have added more detailed instructions, better screenshots and annotations.
So you can get up-and-running _even_ faster!

> _This_ guide is checked periodically by the @dwyl team/community,
but Github are known to occasionally change their UI/Workflow,
so if anything has changed, or there are extra/fewer steps,
[please let us know!](https://github.com/dwyl/elixir-auth-github/issues)



## 1. Open Your GitHub Account Settings

In your web browser,
visit:
https://github.com/settings/developers

![github-auth-01-developer-settings](https://user-images.githubusercontent.com/194400/71082035-4bd8f500-2188-11ea-9c81-8415b1ba1017.png)


Click on the "**Register a new application**" button. <br />
(_Note: the button text will be "**New OAuth App**"
if you already have existing apps_)


## 2. Define the details for your application

Ensure that you set the `callback URL`
to `/auth/github/callback`

![github-auth-02-new-app-register](https://user-images.githubusercontent.com/194400/71096308-f4498200-21a5-11ea-938b-90f2879af240.png)

*Note: You can edit/change any of these values later*.

Click on **Register Application**

Once your application is successfully created
you should see an application settings page similar to this:

![github-auth-03-new-app-credentials](https://user-images.githubusercontent.com/194400/71096462-42f71c00-21a6-11ea-9358-f0886c227f9c.png)

## 3. Copy the Client ID & Secret for the App

Once you have the credentials for your OAuth Client,
export them as **environment variables**
so that your Elixir/Phoenix app can access them.

> If you are new to environment variables,
please see:
[github.com/dwyl/learn-environment-variables](https://github.com/dwyl/learn-environment-variables)

In our case we add the credentials
to an **`.env`** (_environment variables_) file.

Locate the `Client ID` and `Client Secret` on the App settings page.
Copy the values of the `Client ID` and `Client Secret`
and save them as environment variables
`GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` respectively.


```yml
GITHUB_CLIENT_ID=d6fca75c63daa014c187
GITHUB_CLIENT_SECRET=8eeb143935d1a505692aaef856db9b4da8245f3c
```


Copy the two keys and export them in your project
see: **Step 3** of the
[README.md](https://github.com/dwyl/elixir-auth-github/blob/master/create-github-app-guide.md)


<br />

# Note

When you ship your app to your Production environment,
you will need to re-visit steps 3 & 4
to update your app settings URL & callback
to reflect the URl where you are deploying your app e.g:


In our case
https://elixir-auth-github-demo.herokuapp.com
and
https://elixir-auth-github-demo.herokuapp.com/auth/google/callback
