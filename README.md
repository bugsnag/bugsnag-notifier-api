Bugsnag Notifier API
====================

The Bugsnag Notifier API can be used to notify Bugsnag of an error or
exception in web, mobile or desktop applications.
[Official notifiers](https://bugsnag.com/docs/notifiers) are available
for many languages and frameworks.

If there is no notifier available for the language or framework you are using,
then why not write one yourself? Email us at
[notifiers@bugsnag.com](mailto:notifiers@bugsnag.com) to let us know about
your new notifier, and we will make it available to other Bugsnag users. We
will even give you special Bugsnag perks to say thank you!

[Bugsnag](http://bugsnag.com) captures errors in real-time from your web,
mobile and desktop applications, helping you to understand and resolve them
as fast as possible. [Create a free account](http://bugsnag.com) to start
capturing exceptions from your applications.


API Overview
------------

Bugsnag provides a simple JSON based API to notify us of errors. Simply
POST the [JSON Payload](#json-payload) to [https://notify.bugsnag.com](https://notify.bugsnag.com)
and Bugsnag will process the error.

If for some reason you cannot make HTTPS requests, you can use the non-https URL
[http://notify.bugsnag.com](http://notify.bugsnag.com)

Make sure you set the HTTP `Content-Type` header to be `application/json`.

Response Codes
--------------

Bugsnag doesn't parse or analyze requests synchronously, so we only use two response
codes:

-   **200 (OK)**

    The payload was accepted and will be processed asynchronously. This doesn't imply
    that your payload was valid, just that it was enqueued to be processed.

-   **400 (Bad Request)**

    The payload was too large or took too long (>10s) to read from the network.

JSON Payload
------------

Here is the JSON payload for a notice to Bugsnag that an error has occurred in
an application. All fields are required, unless otherwise stated.

Fields marked as searchable can be searched from the Bugsnag dashboard, and those
marked as filtered are available for filtering.

```javascript
{
    // The API Key associated with the project. Informs Bugsnag which project
    // has generated this error.
    apiKey: "c9d60ae4c7e70c4b6c4ebd3e8056d2b8",

    // This object describes the notifier itself. These properties are used
    // within Bugsnag to track error rates from a notifier.
    notifier: {

        // The notifier name
        name: "Bugsnag Ruby",

        // The notifier's current version
        version: "1.0.11",

        // The URL associated with the notifier
        url: "https://github.com/bugsnag/bugsnag-ruby"
    },

    // An array of error events that Bugsnag should be notified of. A notifier
    // can choose to group notices into an array to minimize network traffic, or
    // can notify Bugsnag each time an event occurs.
    events: [{

        // The version number of the payload. If not set to 2+, Severity will
        // not be supported.
        // (required, must be set to "2")
        payloadVersion: "2",

        // An array of exceptions that occurred during this event. Most of the
        // time there will only be one exception, but some languages support
        // "nested" or "caused by" exceptions. In this case, exceptions should
        // be unwrapped and added to the array one at a time. The first
        // exception raised should be first in this array.
        exceptions: [{

            // The class of error that occurred. This field is used to group the
            // errors together so should not contain any contextual information
            // that would prevent correct grouping. This would ordinarily be the
            // Exception name when dealing with an exception.
            // (searchable)
            errorClass: "NoMethodError",

            // The error message associated with the error. Usually this will
            // contain some information about this specific instance of the
            // error and is not used to group the errors (optional, default
            // none). (searchable)
            message: "Unable to connect to database.",

            // An array of stacktrace objects. Each object represents one line
            // in the exception's stacktrace. Bugsnag uses this information to
            // help with error grouping, as well as displaying it to the user.
            stacktrace: [{

                // The file that this stack frame was executing.
                // It is recommended that you strip any unnecessary or common
                // information from the beginning of the path.
                file: "controllers/auth/session_controller.rb",

                // The line of the file that this frame of the stack was in.
                lineNumber: 1234,

                // The column of the file that this frame of the stack was in.
                // (optional)
                columnNumber: 123,

                // The method that this particular stack frame is within.
                method: "create",

                // Is this stacktrace line is in the user's project code, set
                // this to true. It is useful for developers to be able to see
                // which lines of a stacktrace are within their own application,
                // and which are within third party libraries. This boolean
                // field allows Bugsnag to display this information in the
                // stacktrace as well as use the information to help group
                // errors better.
                // (Optional, defaults to false).
                inProject: true
            }]
        }],

        // An array of background threads.
        // This is optional but recommended for apps that rely heavily on threading.
        // Threads should be in an order that makes sense for your application.
        // (optional)
        threads: [{
            // The id of the thread in your application.
            // (optional)
            id: "thread_id",

            // A human readable name for the thread.
            // (optional)
            name: "thread_name",

            // An array of stacktrace objects. Each object represents one line
            // in the stacktrace of the thread at the point your program crashed.
            stacktrace: [{
                // This object has the same format as the stacktrace object on exceptions.
            }]

        }],

        // A string representing what was happening in the application at the
        // time of the error. This string could be used for grouping purposes,
        // depending on the event.
        // Usually this would represent the controller and action in a server
        // based project. It could represent the screen that the user was
        // interacting with in a client side project.
        // For example,
        //   * On Ruby on Rails the context could be controller#action
        //   * In Android, the context could be the top most Activity.
        //   * In iOS, the context could be the name of the top most
        //     UIViewController
        // (optional, searchable)
        context: "auth/session#create",

        // All errors with the same groupingHash will be grouped together within
        // the bugsnag dashboard.
        // This gives a notifier more control as to how grouping should be
        // performed. We recommend including the errorClass of the exception in
        // here so a different class of error will be grouped separately.
        // (optional)
        groupingHash: "buggy_file.rb",

        // The severity of the error. This can be set to:
        // - "error"   used when the app crashes
        // - "warning" used when Bugsnag.notify is called
        // - "info"    can be used in manual Bugsnag.notify calls
        // (optional, default "error", filtered)
        severity: "error",

        // Information about the user affected by the crash.
        // These fields are optional but highly recommended.
        user: {

            // A unique identifier for a user affected by this event. This could
            // be any distinct identifier that makes sense for your
            // application/platform.
            // (optional, searchable)
            id: "19",

            // The user's name, or a string you use to identify them.
            // (optional, searchable)
            name: "Simon Maynard",

            // The user's email address.
            // (optional, searchable)
            email: "simon@bugsnag.com"
        },

        // Information about the app that crashed.
        // These fields are optional but highly recommended
        app: {
          // The version number of the application which generated the error.
          // If appVersion is set and an error is resolved in the dashboard
          // the error will not unresolve until a crash is seen in a newer
          // version of the app.
          // (optional, default none, filtered)
          version: "1.1.3",

          // The release stage that this error occurred in, for example
          // "development", "staging" or "production".
          // (optional, default "production", filtered)
          releaseStage: "production",
        },

        // Information about the computer/device running the app
        // These fields are optional but highly recommended
        device: {
          // The operating system version of the client that the error was
          // generated on. (optional, default none)
          osVersion: "2.1.1",

          // The hostname of the server running your code
          // (optional, default none)
          hostname: "web1.internal"
        }

        // An object containing any further data you wish to attach to this
        // error event. This should contain one or more objects, with each
        // object being displayed in its own tab on the event details on the
        // Bugsnag website.
        // (Optional).
        metaData: {

            // This will displayed as the first tab after the stacktrace on the
            // Bugsnag website.
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
    be sent to Bugsnag.

-   **autoNotify**

    If this is true, the plugin should notify Bugsnag of any uncaught
    exceptions (if possible). This should default to true.

-   **useSSL**

    If this is true, the plugin should notify Bugsnag using SSL.
    This should default to true.


### Per-Session Settings

You should also allow developers to set the following settings on a *per-request*
or *per-session* basis. These settings allow us to attach meta-data to each
error:

-   **user**

    An object representing the current application's user, which can include ID,
    email address, and username. Many platforms have a way to automatically fill
    this, for example `session` data in rails apps.
    You could also generate a UUID and store this on the user's device or in
    their session. Even if you automatically choose a user.id, you should
    still allow developers to set one themselves.
    You should send this value in the [JSON Payload](#json-payload).

-   **context**

    Allow the developer to set the context that is currently active in the
    application. You should default this to something sensible for the
    platform, for example "action#controller" in a rails app.
    You should send this value in the [JSON Payload](#json-payload).

-   **metaData**

    Allow the developer to set any extra data that will be sent as meta-data
    along with every error. You should send this value inside `metaData`
    in the [JSON Payload](#json-payload).
