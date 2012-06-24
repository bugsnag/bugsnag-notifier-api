Bugsnag Notifier API
====================

The Bugsnag Notifier API can be used to notify Bugsnag of an error or 
exception in web, mobile or desktop applications.
[Official notifiers](https://github.com/organizations/bugsnag) are available 
for several languages and frameworks.

If there is no notifier available for the language or framework you are using,
then why not write one yourself? Email us at 
[notifiers@bugsnag.com](mailto:notifiers@bugsnag.com) to let us know about 
your new notifier, and we will make it available to other Bugsnag users. We 
will even give you special Bugsnag perks to say thank you!


What is Bugsnag?
----------------

[Bugsnag](http://bugsnag.com) captures errors in real-time from your web, 
mobile and desktop applications, helping you to understand and resolve them 
as fast as possible. [Create a free account](http://bugsnag.com).


API Overview
------------

Bugsnag provides a simple JSON based API to notify us of errors. Simply
POST the [JSON Payload](#json-payload) to [http://notify.bugsnag.com](http://notify.bugsnag.com)
and Bugsnag will process the error.

It is recommended you make it possible to post errors over HTTPS, in which case
you should POST to [https://notify.bugsnag.com](https://notify.bugsnag.com).

Make sure you set the HTTP `Content-Type` header to be `application/json`.


Response Codes
--------------

We use standard HTTP response codes to let you know if your JSON Payload was 
processed sucessfully. For non-200 response codes, we will also include a JSON
response with details of any error that occurred. Bugsnag will send one of the
following response code:

-   **200 (OK)**

    The error validated and will be processed.

-   **400 (Bad Request)**

    The payload failed syntax validation and was not processed.

-   **401 (Unauthorized)**

    Indicates that the API Key was incorrect.

-   **413 (Request Too Large)**
    
    Indicates that the payload was too large to be processed.

-   **429 (Too Many Requests)**

    Indicates that the payload was not processed due to rate limiting.


JSON Payload
------------

Here is the JSON payload for a notice to Bugsnag that an error has occurred in an application.
All fields are required, unless otherwise stated.

```javascript
{
    // The API Key associated with the project. Informs Bugsnag which project has generated this error.
    apiKey: "c9d60ae4c7e70c4b6c4ebd3e8056d2b8",

    // This object describes the notifier itself. These properties are used within Bugsnag to track error 
    // rates from a notifier.
    notifier: {
        
        // The notifiers name. Used internally within Bugsnag to track error rates from notifiers.
        name: "Bugsnag Ruby",

        // The notifiers current version. Used internally within Bugsnag to track error rates from notifiers.
        version: "1.0.11",

        // The URL associated with the notifier.
        url: "https://github.com/bugsnag/bugsnag-ruby"
    },

    // An array of error events that Bugsnag should be notified of. A notifier can choose to group 
    // notices into an array to minimize network traffic, or can notify Bugsnag each time an event occurs. 
    events: [{
        
        // A unique identifier for a user affected by this event. This could be any distinct identifier
        // that makes sense for your application/platform. This field is optional but highly recommended.
        userId: "snmaynard",

        // The version number of the application which generated the error. (optional, default none)
        appVersion: "1.1.3",

        // The release stage that this error occurred in, for example "development" or "production".
        // This can be any string, but "production" will be highlighted differently in bugsnag in the future,
        // so please use "production" appropriately.
        releaseStage: "production",

        // A string representing what was happening in the application at the time of the error. 
        // This string could be used for grouping purposes, depending on the event.
        // Usually this would represent the controller and action in a server based project. 
        // It could represent the screen that the user was interacting with in a client side project.
        // For example,
        //   * On Ruby on Rails the context could be controller#action
        //   * In Android, the context could be the top most Activity.
        //   * In iOS, the context could be the name of the top most UIViewController.
        context: "auth/session#create",

        // An array of exceptions that occurred during this event. Most of the time there will 
        // only be one exception, but some languages support "nested" or "caused by" exceptions.
        // In this case, exceptions should be unwrapped and added to the array one at a time.
        // The first exception raised should be first in this array.
        exceptions: [{
    
            // The class of error that occurred. This field is used to group the errors together 
            // so should not contain any contextual information that would prevent correct grouping. 
            // This would ordinarily be the Exception name when dealing with an exception.
            errorClass: "NoMethodError",
    
            // The error message associated with the error. Usually this will contain some information
            // about this specific instance of the error and is not used to group the errors (optional, default none).
            errorMessage: "Unable to connect to database.",
    
            // An array of stacktrace objects. Each object represents one line in the exception's stacktrace.
            // Bugsnag uses this information to help with error grouping, as well as displaying it to the user.
            stacktrace: [{
                
                // The file that this stack frame was executing.
                // It is recommended that you strip any unnecessary information from the beginning of the path.
                file: "controllers/auth/session_controller.rb",
        
                // The line of the file that this frame of the stack was in.
                lineNumber: 1234,
        
                // The method that this particular stack frame is within.
                method: "create",
        
                // Is this stacktrace line is in the user's project code, set this to true.
                // It is useful for developers to be able to see which lines of a stacktrace are within their own
                // application, and which are within third party libraries. This boolean field allows Bugsnag 
                // to display this information in the stacktrace as well as use the information to help group 
                // errors better. (Optional, defaults to false).
                inProject: true
            }]
        }],

        // An object containing any further data you wish to attach to this error event.
        // This should contain one or more objects, with each object being displayed in its
        // own tab on the event details on the Bugsnag website. (Optional).
        metaData: {
            
            // This will displayed as the first tab after the stacktrace on the Bugsnag website.
            someData: {

                // A key value pair that will be displayed in the first tab
                key: "value",

                // This is shown as a section within the first tab
                setOfKeys: {
                    key: "value",
                    key2: "value"
                }
            },
            
            // This would be the second tab on the Bugsnag website.
            someMoreData: {
                ...
            }
        }
    }]
}
```


Notifier Configuration
----------------------

When writing a notifier, you should consider providing methods to allow users
to configure how errors are sent to bugsnag.

On our official notifiers, we provide the following interfaces:

### Application Settings

Your Bugsnag notifier should allow users to set the following settings in
their application.

-   **apiKey**

    The apiKey for the project, this **must** be provided by the developer.
    You should send this value in the [JSON Payload](#json-payload).

-   **releaseStage**
    
    The current release stage for the application. Most platforms have a
    sensible automatic way of obtaining this, for example `RAILS_ENV` 
    in rails apps, and this should be used if possible.
    You should send this value in the [JSON Payload](#json-payload).

-   **notifyReleaseStages**

    A list of release stages that the notifier will capture and send errors 
    for. If the current release stage is not in this list, errors should not 
    be sent to Bugsnag. This should default to notifying for the "production"
    release stage only.

-   **autoNotify**

    If this is true, the plugin should notify Bugsnag of any uncaught 
    exceptions (if possible). This should default to true.

-   **useSSL**

    If this is true, the plugin should notify Bugsnag using SSL.
    This should default to false.


### Per-Session Settings

You should also allow developers to set the following settings on a *per-request*
or *per-session* basis. These settings allow us to attach meta-data to each 
error:

-   **userId**

    An ID representing the current application's user. Many platforms have a
    way to automatically fill this, for example `session` data in rails apps.
    You could also generate a UUID and store this on the user's device or in
    their session. Even if you automatically choose a userId, you should 
    still allow developers to set one themselves.
    You should send this value in the [JSON Payload](#json-payload).

-   **context**

    Allow the developer to set the context that is currently active in the 
    application. You should default this to something sensible for the 
    platform, for example "action#controller" in a rails app.
    You should send this value in the [JSON Payload](#json-payload).

-   **extraData**

    Allow the developer to set any extra data that will be sent as meta-data 
    along with every error. You should send this value inside `metaData` 
    in the [JSON Payload](#json-payload).