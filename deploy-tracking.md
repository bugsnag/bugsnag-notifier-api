Bugsnag Deploy Tracking API
===========================

The Bugsnag Deploy Tracking API allows you to track deploys of your apps.
By sending the source revision or application version to bugsnag.com when
you deploy a new version of your app, you'll be able to see which deploy each
error was introduced in.

Our [official notifiers](https://bugsnag.com/docs/notifiers) will often
contain language or frameworks hooks to help you automate the deploy
notification process. If you are using a custom notifier, or your notifier
does provide appropriate deploy tracking hooks, you can notify Bugsnag of
deploys of your application using the deploy tracking API described here.

[Bugsnag](http://bugsnag.com) captures errors in real-time from your web,
mobile and desktop applications, helping you to understand and resolve them
as fast as possible. [Create a free account](http://bugsnag.com) to start
capturing exceptions from your applications.


API Overview
------------

To notify Bugsnag of deploys, simply make a HTTP POST to
[http://notify.bugsnag.com/deploy](http://notify.bugsnag.com/deploy)
and Bugsnag will save and process the deploy information.

The POST payload should be form encoded and have the content type
`application/x-www-form-urlencoded`.

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


Example
-------

Notify Bugsnag of a deploy using `curl`:

```shell
curl -d "apiKey=YOUR_API_KEY_HERE&appVersion=1.5" http://notify.bugsnag.com/deploy
```

> Note: To configure deploy tracking, replace the example text with your project's API token, found on its project settings page.
