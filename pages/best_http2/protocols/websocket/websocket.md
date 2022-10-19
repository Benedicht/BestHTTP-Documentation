---
title: Websocket
sidebar: best_http2_main_sidebar
summary: WebSocket is a high level protocol compared to plain TCP connections, while it keeps similiarities with its simple API. While they have similar naming too, it must be highlighted that a WebSocket connection must go through a HTTP upgrade process and it can't connect to a plain TCP socket that implements a custom protcol to exchange messages!
---


## Constructors

Constructor to specify only the server's endpoint:
```csharp
var webSocket = new WebSocket(new Uri("wss://echo.websocket.org"));
```

Constructor to add origin, protocol and used extension information:

```csharp
var webSocket = new WebSocket(uri: new Uri("wss://echo.websocket.org"), origin: "echo.websocket.org", protocol: "Echo", extensions: null);
```

{% include warning.html content="The *extension* parameter isn't available under WebGL!" %}

## Events

- ### OnOpen

Called when connection to the server is established. After this event the WebSocket’s IsOpen property will be True until we or the server closes the connection or if an error occurs.

```csharp
webSocket.OnOpen += OnWebSocketOpen;
private void OnWebSocketOpen(WebSocket webSocket)
{
	Debug.Log("WebSocket is now Open!");
}
```

- ### OnMessage

Called when a textual message received from the server.

```csharp
webSocket.OnMessage += OnMessageReceived;
private void OnMessageReceived(WebSocket webSocket, string message)
{
	Debug.Log("Text Message received from server: " + message);
}
```

- ### OnBinary

Called when a binary blob message received from the server.

```csharp
webSocket.OnBinary += OnBinaryMessageReceived;
private void OnBinaryMessageReceived(WebSocket webSocket, byte[] message)
{
	Debug.Log("Binary Message received from server. Length: " + message.Length);
}
```

- ### OnBinaryNoAlloc

New in v2.7.0. This is almost the same as `OnBinary`, but instead of receiving a byte array, it receives a `BufferSegment`:

```csharp
webSocket.OnBinaryNoAlloc += OnBinaryNoAlloc;

private void OnBinaryNoAlloc(WebSocket webSocket, BufferSegment buffer)
{
    Debug.Log("Binary Message received from server. Length: " + buffer.Count);
}
```

The received bytes can be accessed through the buffer's `Data` field. In most cases `Data` is a larger array then the received message so it's important to use the buffer's `Count` field instead of `Data.Length`!

```csharp
private void OnBinaryNoAlloc(WebSocket webSocket, BufferSegment buffer)
{
    Debug.Log("Binary Message received from server. Length: " + buffer.Count);

    using (var stream = System.IO.File.OpenWrite("path\to\file"))
    {
        // This is BAD, don't use it like this!
        //stream.Write(buffer.Data, 0, buffer.Data.Length);

        // Good:
        stream.Write(buffer.Data, buffer.Offset, buffer.Count);
    }
}
```

{% include warning.html content="The content of the buffer must be used or copied to a new array in the callbacks because the plugin reuses the memory immediately after the callback by placing it back to the [BufferPool](../../global_topics/BufferPool.html)!" %}

- ### OnClosed

Called when the client or the server closes the connection. When the client closes the connection through the Close function it can provide a Code and a Message that indicates the reason for closing. The server typically will echoes our Code and Message back.

```csharp
webSocket.OnClosed += OnWebSocketClosed;
private void OnWebSocketClosed(WebSocket webSocket, UInt16 code, string message)
{
	Debug.Log("WebSocket is now Closed!");
}
```

- ### OnError

Called when can’t connect to the server, an internal error occurs or when the connection is lost. The second parameter is string describing the error.

```csharp
webSocket.OnError += OnError;

void OnError(WebSocket ws, string error)
{
	Debug.LogError("Error: " + error);
}
```

{% include warning.html content="`OnClose` and `OnError` are mutually exclusive! When `OnError` is called no `OnClosed` going to be triggered. But, the connections is closed in both cases.<br/>
When `OnClose` is called, the plugin could receive and send a close frame to the server and even if there were some kind of error (protocol error, too big message, etc), the tcp connection is healthy and the server could inform the client that it's about to close the connection.<br/>
On the other hand, when `OnError` is called, that's because something really bad happened (tcp channel disconnected for example). In case when the editor is exiting from play mode, the plugin has no time sending a close frame to the server and waiting for an answer, so it just shuts down everything immediately." %}

- ### OnIncompleteFrame

Longer text or binary messages are fragmented, these fragments are assembled by the plugin automatically by default. This mechanism can be overwritten if we register an event handler to the WebSocket’s `OnIncompleteFrame` event. This event called every time the client receives an incomplete fragment. If an event hanler is added to `OnIncompleteFrame`, incomplete fragments going to be ignored by the plugin and it doesn’t try to assemble these nor store them. This event can be used to achieve streaming experience. It's not available under WebGL!

- ### OnInternalRequestCreated

Called when the internal `HTTPRequest` object created. The plugin might call it more than once for one WebSocket instance if it has to fall back from the HTTP/2 implementation to the HTTP/1 one. It's not available under WebGL.

## Methods

All methods are non-blocking, `Open` and `Close` just starts the opening and closing logic, `Send` places the data to a buffer that will be picked up by the sender thread.

- ### Open

Calling `Open()` we can start the connection procedure to the server.

```csharp
webSocket.Open();
```
{% include note.html content="Just as other calls, Open is **not** a blocking call. Messages can be sent to the server after an **OnOpen** event." %}

- ### Send

Send has a few overrides, but the most common is to send text or binary.

Sending out text messages:
```csharp
webSocket.Send("Message to the Server");
```

Sending out binary messages:
```csharp
// Allocate and fill up the buffer with data
byte[] buffer = new byte[length];

webSocket.Send(buffer);
```

Large messages (larger than 32767 bytes by default) are sent fragmented to the server.

Websocket frames produced by the `Send` methods are placed into an internal queue and a sender thread going to send them one by one. The `BufferedAmount` property keeps track the amount of bytes sitting in this queue. 

- ### `SendAsText(BufferSegment data)`

Will send data as a text frame and takes owenership over the memory region releasing it to the [BufferPool](../../global_topics/BufferPool.html) as soon as possible.

- ### `SendAsBinary(BufferSegment data)`

Will send the data in one or more binary frame and takes ownership over it calling [BufferPool](../../global_topics/BufferPool.html).Release when sent.

- ### Close

After all communication is done we should close the connection by calling the `Close()` method.

```csharp
webSocket.Close();
```

{% include note.html content="You can’t reuse a closed WebSocket instance, you have to create and setup a new one." %}

## Properties

- ### IsOpen

It's `true` if the websocket connection is open for sending and receiving.

- ### State

It's more verbose about the sate of the WebSocket than the `IsOpen` property. State can be `Connecting`, `Open`, `Closing`, `Closed` and `Unknown`.

- ### BufferedAmount

The amount of unsent, buffered up data in bytes.

- ### StartPingThread

Set to `true` to let the plugin send ping messages periodically to the server. Its default value is false. It's not available under WebGL!

- ### PingFrequency

The delay between two ping messages in milliseconds. Its default value is 1000 (1 second). It's not available under WebGL!

- ### CloseAfterNoMesssage

If `StartPingThread` set to true, the plugin will close the connection and emit an `OnError` event if no message is received from the server in the given time. Its default value is 2 sec. It's not available under WebGL!

- ### InternalRequest

The internal `HTTPRequest` object the plugin uses to send the websocket upgrade request to the server. It's not available under WebGL! To customize this internal request, use the `OnInternalRequestCreated` callback:

```csharp
string token = "...";

var ws = new WebSocket(new Uri("wss://server.com/"));
ws.OnInternalRequestCreated += (ws, req) => req.AddHeader("Authentication", $"Bearer {token}");
```

- ### Extensions

`IExtension` implementations the plugin will negotiate with the server to use. It's not available under WebGL!

- ### Latency

If `StartPingThread` is set to `true`, the plugin going to calculate Latency from the ping-pong message round-trip times. It's not available under WebGL!

- ### LastMessageReceived

When the last message is received from the server. It's not available under WebGL!

- ### Context

[LoggingContext](../../global_topics/Logging.md#loggingcontext) instance used for logging.