We can use the WebSocket protocol through the WebSocket class. We just need to pass the Uri of the server to the WebSocket’s constructor:

```language-csharp
var webSocket = new WebSocket(new Uri("wss://echo.websocket.org"));
```

After this step we can register our event handlers to several events:

- **OnOpen** event: Called when connection to the server is established. After this event the WebSocket’s IsOpen property will be True until we or the server closes the connection or if an error occurs.

```language-csharp
webSocket.OnOpen += OnWebSocketOpen;
private void OnWebSocketOpen(WebSocket webSocket)
{
	Debug.Log("WebSocket Open!");
}
```

- **OnMessage** event: Called when a textual message received from the server.

```language-csharp
webSocket.OnMessage += OnMessageReceived;
private void OnMessageReceived(WebSocket webSocket, string message)
{
	Debug.Log("Text Message received from server: " + message);
}
```

- **OnBinary** event: Called when a binary blob message received from the server.

```language-csharp
webSocket.OnBinary += OnBinaryMessageReceived;
private void OnBinaryMessageReceived(WebSocket webSocket, byte[] message)
{
	Debug.Log("Binary Message received from server. Length: " + message.Length);
}
```

- **OnClosed** event: Called when the client or the server closes the connection, or an internal error occurs. When the client closes the connection through the Close function it can provide a Code and a Message that indicates a reason for closing. The server typically will echos our Code and Message.

```language-csharp
webSocket.OnClosed += OnWebSocketClosed;
private void OnWebSocketClosed(WebSocket webSocket, UInt16 code, string message)
{
	Debug.Log("WebSocket Closed!");
}
```

- **OnError** event: Called when can’t connect to the server, an internal error occurs or when the connection is lost. The second parameter is an Exception object, but it can be null. In this case, checking the InternalRequest of the WebSocket should tell more about the problem.

```language-csharp
webSocket.OnError += OnError;

void OnError(WebSocket ws, string error)
{
	Debug.Log("Error: " + error);
}
```

- **OnIncompleteFrame** event: See Streaming at the [Advanced Websocket](Advanced WebSocket.md) topic.

After we registered to the event we can start open the connection:

```language-csharp
webSocket.Open();
```
!!! Notice
	Just as other calls, Open is **not** a blocking call. Messages can be sent to the server after an **OnOpen** event.

After this step we will receive an OnOpen event and we can start sending out messages to the server.

```language-csharp
// Sending out text messages:
webSocket.Send("Message to the Server");

byte[] buffer = new byte[length];
//fill up the buffer with data

// Sending out binary messages:
webSocket.Send(buffer);
```

After all communication is done we should close the connection:

```language-csharp
webSocket.Close();
```

You can’t reuse a closed WebSocket instance.