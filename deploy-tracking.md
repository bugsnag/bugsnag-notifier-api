Bugsnag Deploy Tracking API
===========================

The Bugsnag Deploy Tracking API allows you to track deploys of your apps.
By sending the source revision or application version when
you deploy a new version of your app, you'll be able to see which deploy each
error was introduced in.

[Bugsnag](https://bugsnag.com) automatically detects errors in your web,
mobile and desktop applications, collecting diagnostic information and immediately notifying your development team.

[Create a free account](https://bugsnag.com) to start
capturing exceptions from your applications.

Contents
--------

- [API Overview](#api-overview)
- [Curl Example](#curl-example)
- [Capistrano Integration](#capistrano-integration)
- [Rake Integration](#rake-integration)
- [Heroku Deploy Hooks](#heroku-deploy-hook)


API Overview
------------

If you are using a custom notifier, or your notifier
does provide appropriate deploy tracking hooks, you can notify Bugsnag of
deploys of your application using the deploy tracking API described here.
To notify Bugsnag of deploys, simply make a HTTP POST to
[http://notify.bugsnag.com/deploy](http://notify.bugsnag.com/deploy)
and Bugsnag will save and process the deploy information.

The POST payload can either be normal form-encoded data, or a JSON object. If
you choose to POST a JSON object, make sure you set the HTTP `Content-Type`
header to be `application/json`.

You can post the following fields when notifying Bugsnag of a deploy:

-   **apiKey**

    The API Key associated with the project. Informs Bugsnag which project
    has been deployed. This is the only required field.

-   **releaseStage**

    The release stage (eg, production, staging) currently being deployed.
    (Optional, defaults to "production").

-   **repository**

    The url to the repository containing the source code being deployed.
    We can use this to link directly to your source code from the Bugsnag
    dashboard. (Optional).

-   **branch**

    The source control branch from which you are deploying the code.
    (Optional).

-   **revision**

    The source control (git, subversion, etc) revision id for the code you
    are deploying. (Optional).

-   **appVersion**

    The app version of the code you are currently deploying. Only set this
    if you tag your releases with [semantic version numbers](http://semver.org/)
    and deploy infrequently. (Optional).


Curl Example
------------

Notify Bugsnag of a deploy using `curl`:

```shell
curl -d "apiKey=YOUR_API_KEY_HERE&appVersion=1.5" http://notify.bugsnag.com/deploy
```

> Note: To configure deploy tracking, replace the example text with your project's API token, found on its project settings page.


Capistrano Integration
----------------------

See the [bugsnag-ruby docs](https://bugsnag.com/docs/notifiers/ruby#using-capistrano) for how to track deploys with Capistrano.


Rake Integration
----------------

See the [bugsnag-ruby docs](https://bugsnag.com/docs/notifiers/ruby#using-rake) for how to track deploys from your Rake tasks.


Heroku Deploy Hooks
-------------------

If you are using Bugnag with a ruby application on Heroku, you can use our rake rask to quickly add a deploy hook:

```
$ rake bugsnag:heroku:add_deploy_hook
```

For other types of Heroku application, you can run the following command to add a Heroku deploy hook:

```
$ heroku addons:add deployhooks:http --url="https://notify.bugsnag.com/deploy?\
    apiKey=YOUR_API_KEY_HERE&\
    revision={{head_long}}&\
    releaseStage=YOUR_RELEASE_STAGE&\
    repo=YOUR_GITHUB_REPO"
```

> Note: Replace the example text with your project's API token, found on its project settings page.
