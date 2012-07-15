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

The POST payload can either be normal form-encoded data, or a JSON object. If
you choose to POST a JSON object, make sure you set the HTTP `Content-Type`
header to be `application/json`.

You can post the following fields when notifying Bugsnag of a deploy:

-   **apiKey**

    The API Key associated with the project. Informs Bugsnag which project 
    has been deployed.
    
    This is the only required field.

-   **appVersion**

    The app version representing this deploy. If you tag every deploy with a 
    version, send this version number here, otherwise you can send the 
    revision number from your source control system.

    *Optional, defaults to a unix timestamp representing the current time.*
    
-   **releaseStage**

    The release stage for this deploy, eg. "production".
    
    *Optional, defaults to "production".*

-   **repository**

    The url to the respository containing your source code. We can use this to
    link directly to your source code from the Bugsnag dashboard.
    
    *Optional.*


Example
-------

Notify Bugsnag of a deploy using `curl`:

```shell
curl -d "apiKey=c9d60ae4c7e70c4b6c4eb&appVersion=1.5" https://notify.bugsnag.com/deploy
```