cordova-background-plugin
=========================

This plugin supports two iOS 7 APIs for updating your app’s UI and content in the background. The first, Background Fetch, allows you to fetch new content from the network at regular intervals. The second, Remote Notifications, is a feature leveraging Push Notifications to notify an app when an event has occurred. Both of these new mechanisms help you to keep your app’s interface up to date.

Here is how you use it:

```js
backgroundFetch.register('fetching');
```

'fetching' is a name of the function exectuted when the os will poll your application to see if ther is content available. When the call is done you'll have to let the os know if there was content or not so it can schedule the next call.

```js
function fetching() {
    //fetching the content and afterward if successfull
    backgroundFetch.setContentAvailable(backgroundFetch.BackgroundFetchResult.NewData);
}
```

with backgroundFetch.setContentAvailable we _tell_ iOS if there was new data or not `backgroundFetch.BackgroundFetchResult` contains all the options that we can set:
* NewData: 0
* NoData: 1
* Failed: 2

You can also trigger the background fetch by sending a push notification with `content-available` flag set. The console will log the deviceId nessary to send the notification.
