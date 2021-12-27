---
title: Advanced Topics
sidebar: best_http2_main_sidebar
---

## Per-Message Compression Extension

The plugin enables and uses the [Per-Message Compression Extension](https://tools.ietf.org/html/rfc7692) by default. It can be disabled by passing null as the last (extensions) parameter of the websocket constructor.
To change defaults we can use the same constructor, but with a new `PerMessageCompression` object:

```csharp
using BestHTTP.WebSocket;
using BestHTTP.WebSocket.Extensions;

var perMessageCompressionExtension = new PerMessageCompression(/*compression level: */           BestHTTP.Decompression.Zlib.CompressionLevel.Default,
                                                               /*clientNoContextTakeover: */     false,
                                                               /*serverNoContextTakeover: */     false,
                                                               /*clientMaxWindowBits: */         BestHTTP.Decompression.Zlib.ZlibConstants.WindowBitsMax,
                                                               /*desiredServerMaxWindowBits: */  BestHTTP.Decompression.Zlib.ZlibConstants.WindowBitsMax,
                                                               /*minDatalengthToCompress: */     PerMessageCompression.MinDataLengthToCompressDefault);
var webSocket = new WebSocket(new Uri("wss://echo.websocket.org/"), null, null, perMessageCompressionExtension);
```

Extension usage depends on the server too, but if the server agrees to use the extension, the plugin can receive and send compressed messages automatically.

## Implementations

The plugin now have three implementations:

### WebGL

Under WebGL the plugin **must** use the underlying browser's [WebSocket implementation](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket). Browsers are exposing a limited API, hence not all features, methods and properties are available under this platform.

### HTTP/1 Upgrade

This implementation uses HTTP/1 upgrade mechanism. This was the default for every non-webgl platform.

If the server agrees on the upgrade the plugin creates a `WebSocketResponse` object (instead of the regular `HTTPResponse`) to handle message sending and receiving. This `WebSocketResponse` object's lifetime is bound to its websocket object and it's possible to access it after the `OnOpen` event. Accessing it has little usage, but in a few cases it can be beneficial:
```csharp
void OnOpened(WebSocket webSocket)
{
    (webSocket.InternalRequest.Response as WebSocketResponse).MaxFragmentSize = 16 * 1024;
}
```

### WebSocket Over HTTP/2

This new implementation is based on [RFC 8441](https://tools.ietf.org/html/rfc8441) and uses an already open HTTP/2 connection that advertised itself as one that supports the Extended Connect method.
If there's no open HTTP/2 connection the plugin uses the 'old' HTTP/1 based one. Because connecting over the already open HTTP/2 connection still can fail, the plugin can fallback to the HTTP/1 based one. When a fallback happens a new `HTTPRequest` object will be created by the new implementation and the `OnInternalRequestCreated` callback will be called again for this request too. 
If fallback is disabled WebSocket's `OnError` will be called.

This implementation uses the underlying HTTP/2 connection's framing mechanism, the maximum fragment size is the one that the HTTP/2 connection negotiated. 

Both WebSocket Over HTTP/2 and its fallback mechanism can be disabled:

```csharp
// Disable WebSocket Over HTTP/2
HTTPManager.HTTP2Settings.WebSocketOverHTTP2Settings.EnableWebSocketOverHTTP2 = false;

// Disable fallback mechanism
HTTPManager.HTTP2Settings.WebSocketOverHTTP2Settings.EnableImplementationFallback = false;
```

Pros of WebSocket Over HTTP/2:

- Less resource usage both on the client and server
- It doesn't have to do the TCP and TLS handshake round trips
- Better utilization of TCP