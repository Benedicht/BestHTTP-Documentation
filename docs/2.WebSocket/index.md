#WebSocket

WebSocket is a high level protocol compared to plain TCP connections, while it keeps similiarities with its simple API. While they have similar naming too, it must be highlighted that a WebSocket connection must go through a HTTP upgrade process and it can't connect to a plain TCP socket that implements a custom protcol to exchange messages!

## Constructors

Constructor to specify only the server's endpoint:
```language-csharp
var webSocket = new WebSocket(new Uri("wss://echo.websocket.org"));
```

Constructor to add origin, protocol and used extension information:

```language-csharp
var webSocket = new WebSocket(uri: new Uri("wss://echo.websocket.org"), origin: "echo.websocket.org", protocol: "Echo", extensions: null);
```

!!! Warning
	The *extension* parameter isn't available under WebGL!

## Events

- **OnOpen**: Called when connection to the server is established. After this event the WebSocket’s IsOpen property will be True until we or the server closes the connection or if an error occurs.

```language-csharp
webSocket.OnOpen += OnWebSocketOpen;
private void OnWebSocketOpen(WebSocket webSocket)
{
	Debug.Log("WebSocket is now Open!");
}
```

- **OnMessage**: Called when a textual message received from the server.

```language-csharp
webSocket.OnMessage += OnMessageReceived;
private void OnMessageReceived(WebSocket webSocket, string message)
{
	Debug.Log("Text Message received from server: " + message);
}
```

- **OnBinary**: Called when a binary blob message received from the server.

```language-csharp
webSocket.OnBinary += OnBinaryMessageReceived;
private void OnBinaryMessageReceived(WebSocket webSocket, byte[] message)
{
	Debug.Log("Binary Message received from server. Length: " + message.Length);
}
```

- **OnClosed**: Called when the client or the server closes the connection. When the client closes the connection through the Close function it can provide a Code and a Message that indicates the reason for closing. The server typically will echoes our Code and Message back.

```language-csharp
webSocket.OnClosed += OnWebSocketClosed;
private void OnWebSocketClosed(WebSocket webSocket, UInt16 code, string message)
{
	Debug.Log("WebSocket is now Closed!");
}
```

- **OnError**: Called when can’t connect to the server, an internal error occurs or when the connection is lost. The second parameter is string describing the error.

```language-csharp
webSocket.OnError += OnError;

void OnError(WebSocket ws, string error)
{
	Debug.LogError("Error: " + error);
}
```

!!! Warning
	`OnClose` and `OnError` are mutually exclusive! When `OnError` is called no `OnClosed` going to be triggered. But, the connections is closed in both cases. 
	When `OnClose` is called, the plugin could receive and send a close frame to the server and even if there were some kind of error (protocol error, too big message, etc), the tcp connection is healthy and the server could inform the client that it's about to close the connection.
	On the other hand, when `OnError` is called, that's because something really bad happened (tcp channel disconnected for example). In case when the editor is exiting from play mode, the plugin has no time sending a close frame to the server and waiting for an answer, so it just shuts down everything immediately.

- **OnIncompleteFrame**: Longer text or binary messages are fragmented, these fragments are assembled by the plugin automatically by default. This mechanism can be overwritten if we register an event handler to the WebSocket’s `OnIncompleteFrame` event. This event called every time the client receives an incomplete fragment. If an event hanler is added to `OnIncompleteFrame`, incomplete fragments going to be ignored by the plugin and it doesn’t try to assemble these nor store them. This event can be used to achieve streaming experience. It's not available under WebGL!

- **OnInternalRequestCreated**: Called when the internal `HTTPRequest` object created. The plugin might call it more than once for one WebSocket instance if it has to fall back from the HTTP/2 implementation to the HTTP/1 one. It's not available under WebGL.

## Methods

All methods are non-blocking, `Open` and `Close` just starts the opening and closing logic, `Send` places the data to a buffer that will be picked up by the sender thread.

- **Open**: Calling `Open()` we can start the connection procedure to the server.

```language-csharp
webSocket.Open();
```
!!! Notice
	Just as other calls, Open is **not** a blocking call. Messages can be sent to the server after an **OnOpen** event.

- **Send**:

Sending out text messages:
```language-csharp
webSocket.Send("Message to the Server");
```

Sending out binary messages:
```language-csharp
// Allocate and fill up the buffer with data
byte[] buffer = new byte[length];

webSocket.Send(buffer);
```

Large messages (larger than 32767 bytes by default) are sent fragmented to the server.

Websocket frames produced by the `Send` methods are placed into an internal queue and a sender thread going to send them one by one. The `BufferedAmount` property keeps track the amount of bytes sitting in this queue. 

- **Close**: After all communication is done we should close the connection by calling the `Close()` method.

```language-csharp
webSocket.Close();
```

!!! Notice
	You can’t reuse a closed WebSocket instance, you have to create and setup a new one.

## Properties

- **IsOpen**: It's `true` if the websocket connection is open for sending and receiving.
- **State**: It's more verbose about the sate of the WebSocket than the `IsOpen` property. State can be `Connecting`, `Open`, `Closing`, `Closed` and `Unknown`.
- **BufferedAmount**: The amount of unsent, buffered up data in bytes.
- **StartPingThread**: Set to `true` to let the plugin send ping messages periodically to the server. Its default value is false. It's not available under WebGL!
- **PingFrequency**: The delay between two ping messages in milliseconds. Its default value is 1000 (1 second). It's not available under WebGL!
- **CloseAfterNoMesssage**: If `StartPingThread` set to true, the plugin will close the connection and emit an `OnError` event if no message is received from the server in the given time. Its default value is 2 sec. It's not available under WebGL!
- **InternalRequest**: The internal `HTTPRequest` object the plugin uses to send the websocket upgrade request to the server. It's not available under WebGL! To customize this internal request, use the `OnInternalRequestCreated` callback:

```language-csharp
string token = "...";

var ws = new WebSocket(new Uri("wss://server.com/"));
ws.OnInternalRequestCreated += (ws, req) => req.AddHeader("Authentication", $"Bearer {token}");
```

- **Extensions**: `IExtension` implementations the plugin will negotiate with the server to use. It's not available under WebGL!
- **Latency**: If `StartPingThread` is set to `true`, the plugin going to calculate Latency from the ping-pong message round-trip times. It's not available under WebGL!
- **LastMessageReceived**: When the last message is received from the server. It's not available under WebGL!
- **Context**: [LoggingContext](../7.GlobalTopics/Logging.md#loggingcontext) instance used for logging.

## Per-Message Compression Extension

The plugin enables and uses the [Per-Message Compression Extension](https://tools.ietf.org/html/rfc7692) by default. It can be disabled by passing null as the last (extensions) parameter of the websocket constructor.
To change defaults we can use the same constructor, but with a new `PerMessageCompression` object:

```language-csharp
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

#### WebGL

Under WebGL the plugin **must** use the underlying browser's [WebSocket implementation](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket). Browsers are exposing a limited API, hence not all features, methods and properties are available under this platform.

#### HTTP/1 Upgrade

This implementation uses HTTP/1 upgrade mechanism. This was the default for every non-webgl platform.

If the server agrees on the upgrade the plugin creates a `WebSocketResponse` object (instead of the regular `HTTPResponse`) to handle message sending and receiving. This `WebSocketResponse` object's lifetime is bound to its websocket object and it's possible to access it after the `OnOpen` event. Accessing it has little usage, but in a few cases it can be beneficial:
```language-csharp
void OnOpened(WebSocket webSocket)
{
    (webSocket.InternalRequest.Response as WebSocketResponse).MaxFragmentSize = 16 * 1024;
}
```

#### WebSocket Over HTTP/2

This new implementation is based on [RFC 8441](https://tools.ietf.org/html/rfc8441) and uses an already open HTTP/2 connection that advertised itself as one that supports the Extended Connect method.
If there's no open HTTP/2 connection the plugin uses the 'old' HTTP/1 based one. Because connecting over the already open HTTP/2 connection still can fail, the plugin can fallback to the HTTP/1 based one. When a fallback happens a new `HTTPRequest` object will be created by the new implementation and the `OnInternalRequestCreated` callback will be called again for this request too. 
If fallback is disabled WebSocket's `OnError` will be called.

This implementation uses the underlying HTTP/2 connection's framing mechanism, the maximum fragment size is the one that the HTTP/2 connection negotiated. 

Both WebSocket Over HTTP/2 and its fallback mechanism can be disabled:

```language-csharp
// Disable WebSocket Over HTTP/2
HTTPManager.HTTP2Settings.WebSocketOverHTTP2Settings.EnableWebSocketOverHTTP2 = false;

// Disable fallback mechanism
HTTPManager.HTTP2Settings.WebSocketOverHTTP2Settings.EnableImplementationFallback = false;
```

Pros of WebSocket Over HTTP/2:

- Less resource usage both on the client and server
- It doesn't have to do the TCP and TLS handshake round trips
- Better utilization of TCP