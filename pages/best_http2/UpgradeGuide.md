---
title: Upgrade Guide
sidebar: best_http2_main_sidebar
---

## Upgrade from 2.x to 2.6

### HTTPRequest.OnHeaders

`OnHeaders` now receives the headers sent by the server. If the server sends trailing headers too, `OnHeaders` will be called twice: first with the 'regular' headers and the second call will contain the trailing headers only.

```csharp
var request = new HTTPRequest(new Uri("..."));
request.OnHeadersReceived += OnHeaders;
request.Send();

private void OnHeaders(HTTPRequest originalRequest, HTTPResponse response, Dictionary<string, List<string>> headers)
{
        
}
```

### TLS 1.3 related changes

Removed TLS related fields(`UseAlternateSSL`, `CustomCertificateVerifyer`, `CustomClientCredentialsProvider`, `CustomTLSServerNameList`) from `HTTPRequest` as they were not guaranteed to take effect. Now its advised to make generic implementations:

```csharp
using BestHTTP.SecureProtocol.Org.BouncyCastle.Tls;

public sealed class CustomTlsClient : BestHTTP.Connections.TLS.DefaultTls13Client
{
    public CustomTlsClient(Uri uri, List<ServerName> sniServerNames, List<ProtocolName> protocols) : base(uri, sniServerNames, protocols)
    {
    }

    public override TlsCredentials GetClientCredentials(CertificateRequest certificateRequest)
    {
        // TODO: find and return with a client certificate. base._uri contains the original uri the plugin trying to connect to.
        return null;
    }

    public override void NotifyServerCertificate(TlsServerCertificate serverCertificate)
    {
        // TODO: Verify the server sent certificate(s). Throw exceptions when invalid.
    }
}
```

`NotifyServerCertificate`'s serverCertificate parameter now contains both the server certificate chain and a certificate status.

And use it in a custom TLS Client factory:
```csharp
using BestHTTP.SecureProtocol.Org.BouncyCastle.Tls;

HTTPManager.TlsClientFactory = (HTTPRequest request, List<ProtocolName> protocols) =>
{
    List<ServerName> hostNames = null;

    // If there's no user defined one and the host isn't an IP address, add the default one
    if (!request.CurrentUri.IsHostIsAnIPAddress())
    {
        hostNames = new List<ServerName>(1);
        hostNames.Add(new ServerName(0, System.Text.Encoding.UTF8.GetBytes(request.CurrentUri.Host)));
    }

    return new CustomTlsClient(request.CurrentUri, hostNames, protocols);
};
```

Old `CustomCertificateVerifyer` can go to TLS Client's `NotifyServerCertificate` method, `CustomClientCredentialsProvider` to the `GetClientCredentials` function `CustomTLSServerNameList` into the client factory.

## Upgrade from 1.x to 2.x

BestHTTP/2 is a major version upgrade of the *Best HTTP (Pro)* package. Because folders got renamed and features removed, this upgrade isn't a drop-in replace of the old version. The old */Best HTTP (Pro)/* folder must be deleted before importing the new package.

Other breaking changes are:

### General

- [<span style="color:red">Breaking change</span>] Removed Statistics API. There's no replacement API for connection releated (active/inactive connections, requests in queue, etc.) statistics. Cookie and cache releated ones can be done through the `CookieJar` and `HTTPCacheService` classes.
- [<span style="color:red">Breaking change</span>] Changed some BouncyCastle related class' namespace to avoid collision with other plugins and SDKs. Namespaces now starts with `BestHTTP.SecureProtocol.Org.BouncyCastle.` instead of just `Org.BouncyCastle.`.
- [<span style="color:red">Breaking change</span>] Rewrote Abort mechanism. This shouldn't be a breaking change per se, but there might be uncaught bugs.
- [<span style="color:red">Breaking change</span>] Minumum Unity version is now 2017.3 as it's the first version to support .asmdef files. Otherwise the plugin should still work under previous versions too.

### HTTPRequest

- [<span style="color:red">Breaking change</span>] New easier to use http streaming API through the `OnStreamingData` event. So instead of calling `GetStreamedFragments` periodically in the main callback, error handling in the main callback and data processing can be separated:

```csharp
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

```csharp
var request = new HTTPRequest(new Uri("..."), OnRequestFinished);

//request.DisableRetry = true;
request.MaxRetries = 0;

request.Send();
```

- [<span style="color:red">Breaking change</span>] Removed `Priority` property
- [<span style="color:red">Breaking change</span>] Removed `TryToMinimizeTCPLatency` property, because of the plugin's own buffering mechanism it became an always on setting.
- [<span style="color:red">Breaking change</span>] Removed HTTPFormUsage.RawJSon support. There's a [small example](protocols/http/SmallCode-Samples.html#send-json-data) on how a request can be set up to send json with the RawData property.

### Websocket

- [<span style="color:red">Breaking change</span>] Removed OnErrorDesc event
- [<span style="color:red">Breaking change</span>] OnError event now has a string parameter instead of an Exception

```csharp
var webSocket = new WebSocket.WebSocket(new Uri(address));
webSocket.OnError += OnError;

void OnError(WebSocket.WebSocket ws, string error)
{
}
```

### SignalR Core

- [<span style="color:red">Breaking change</span>] Changed up and down streaming API

Documentation about the new and changed streaming API can be found in the [SignalR Core topics](protocols/signalr_core/HubConnection.html#streaming-from-the-server). 
