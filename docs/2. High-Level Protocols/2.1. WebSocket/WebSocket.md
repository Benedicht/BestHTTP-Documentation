WebSocket
We can use the WebSocket feature through the WebSocket class. We just need to pass the Uri of the server to the WebSocket’s constructor:

```csharp
var webSocket = new WebSocket(new Uri("wss://html5labs-interop.cloudapp.net/echo"));
```

After this step we can register our event handlers to several events:

- **OnOpen** event: Called when connection to the server is established. After this event the WebSocket’s IsOpen property will be True until we or the server closes the connection or if an error occurs.

```csharp
webSocket.OnOpen += OnWebSocketOpen;
private void OnWebSocketOpen(WebSocket webSocket)
{
	Debug.Log("WebSocket Open!");
}
```

- **OnMessage** event: Called when a textual message received from the server.

```csharp
webSocket.OnMessage += OnMessageReceived;
private void OnMessageReceived(WebSocket webSocket, string message)
{
	Debug.Log("Text Message received from server: " + message);
}
```

- **OnBinary** event: Called when a binary blob message received from the server.

```csharp
webSocket.OnBinary += OnBinaryMessageReceived;
private void OnBinaryMessageReceived(WebSocket webSocket, byte[] message)
{
	Debug.Log("Binary Message received from server. Length: " + message.Length);
}
```

- **OnClosed** event: Called when the client or the server closes the connection, or an internal error occurs. When the client closes the connection through the Close function it can provide a Code and a Message that indicates a reason for closing. The server typically will echos our Code and Message.

```csharp
webSocket.OnClosed += OnWebSocketClosed;
private void OnWebSocketClosed(WebSocket webSocket, UInt16 code, string message)
{
	Debug.Log("WebSocket Closed!");
}
```

- **OnError** event: Called when we can’t connect to the server, an internal error occurs or when the connection lost. The second parameter is an Exception object, but it can be null. In this case, checking the InternalRequest of the WebSocket should tell more about the problem.

```csharp
webSocket.OnError += OnError;
private void OnError(WebSocket ws, Exception ex)
{
string errorMsg = string .Empty;
if (ws.InternalRequest.Response != null)
errorMsg = string.Format("Status Code from Server: {0} and Message: {1}",
ws.InternalRequest.Response.StatusCode,
ws.InternalRequest.Response.Message);

Debug.Log("An error occured: " + (ex != null ? ex.Message : "Unknown: " + errorMsg));
}
```

- **OnErrorDesc** event: A more informative event then the OnError, as the later is called only with an Exception parameter. This event called after the OnError event, but it could provide a more detailed error report.

```csharp
webSocket.OnErrorDesc += OnErrorDesc;

void OnErrorDesc(WebSocket ws, string error)
{
	Debug.Log("Error: " + error);
}
```

- **OnIncompleteFrame** event: See Streaming at the [Advanced Websocket](2.1.1. Advanced WebSocket/Advanced WebSocket.md) topic.

After we registered to the event we can start open the connection:

```csharp
webSocket.Open();
```

After this step we will receive an OnOpen event and we can start sending out messages to the server.

```csharp
// Sending out text messages:
webSocket.Send("Message to the Server");

// Sending out binary messages:
byte[] buffer = new byte[length];
//fill up the buffer with data
webSocket.Send(buffer);
```

After all communication is done we should close the connection:

```csharp
webSocket.Close();
```

You can’t reuse a closed WebSocket instance.