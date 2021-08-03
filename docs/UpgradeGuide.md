## Upgrade from 1.x to 2.x

BestHTTP/2 is a major version upgrade of the *Best HTTP (Pro)* package. Because folders got renamed and features removed, this upgrade isn't a drop-in replace of the old version. The old */Best HTTP (Pro)/* folder must be deleted before importing the new package.

Other breaking changes are:

## General

- [<span style="color:red">Breaking change</span>] Removed Statistics API. There's no replacement API for connection releated (active/inactive connections, requests in queue, etc.) statistics. Cookie and cache releated ones can be done through the `CookieJar` and `HTTPCacheService` classes.
- [<span style="color:red">Breaking change</span>] Changed some BouncyCastle related class' namespace to avoid collision with other plugins and SDKs. Namespaces now starts with `BestHTTP.SecureProtocol.Org.BouncyCastle.` instead of just `Org.BouncyCastle.`.
- [<span style="color:red">Breaking change</span>] Rewrote Abort mechanism. This shouldn't be a breaking change per se, but there might be uncaught bugs.
- [<span style="color:red">Breaking change</span>] Minumum Unity version is now 2017.3 as it's the first version to support .asmdef files. Otherwise the plugin should still work under previous versions too.

## HTTPRequest

- [<span style="color:red">Breaking change</span>] New easier to use http streaming API through the `OnStreamingData` event. So instead of calling `GetStreamedFragments` periodically in the main callback, error handling in the main callback and data processing can be separated:

```language-csharp
var request = new HTTPRequest(new Uri("..."), OnRequestFinished);
request.OnStreamingData += OnDataDownloaded;

void OnDataDownloaded(HTTPRequest request, HTTPResponse response, byte[] data, int dataLength)
{
    this.ProcessedBytes += dataLength;
    SetDataProcessedUI(this.ProcessedBytes, this.DownloadLength);

    // TODO: process downloaded data
}
```

- [<span style="color:red">Breaking change</span>] `UseStreaming` is an internal property now. When there's a callback specified for `OnStreamingData`, the request automatically becomes a streaming request.
- [<span style="color:red">Breaking change</span>] Removed `GetStreamedFragments` function, use the new `OnStreamingData` event.
- [<span style="color:red">Breaking change</span>] Renamed `OnProgress` to `OnDownloadProgress`
- [<span style="color:red">Breaking change</span>] Removed `DisableRetry`, use `MaxRetries` instead:
```language-csharp
var request = new HTTPRequest(new Uri("..."), OnRequestFinished);

//request.DisableRetry = true;
request.MaxRetries = 0;

request.Send();
```
- [<span style="color:red">Breaking change</span>] Removed `Priority` property
- [<span style="color:red">Breaking change</span>] Removed `TryToMinimizeTCPLatency` property, because of the plugin's own buffering mechanism it became an always on setting.
- [<span style="color:red">Breaking change</span>] Removed HTTPFormUsage.RawJSon support. There's a [small example](/1.HTTP/AdvancedTopics/SmallCode-Samples/#send-json-data) on how a request can be set up to send json with the RawData property.

## Websocket

- [<span style="color:red">Breaking change</span>] Removed OnErrorDesc event
- [<span style="color:red">Breaking change</span>] OnError event now has a string parameter instead of an Exception

```language-csharp
var webSocket = new WebSocket.WebSocket(new Uri(address));
webSocket.OnError += OnError;

void OnError(WebSocket.WebSocket ws, string error)
{
}
```

## SignalR Core

- [<span style="color:red">Breaking change</span>] Changed up and down streaming API

Documentation about the new and changed streaming API can be found in the [SignalR Core topics](/6.SignalRCore/1.HubConnection/#streaming-from-the-server). 
