---
title: General Events
sidebar: best_http2_main_sidebar
---

# Handling general events
The Connection class will allow you to subscribe to multiple events. These events are the following:

- **OnConnected**: This event is fired when the connection class successfully connected, and the SignalR protocol is up for communication.

```csharp
signalRConnection.OnConnected += (con) => Debug.Log("Connected to the SignalR server!");
```

- **OnClosed**: This event is fired when the SignalR protocol is closed, and no further messages are sent or received.

```csharp
signalRConnection.OnClosed += (con) => Debug.Log("Connection Closed");
```

- **OnError**: Called when an error occurs. If the connection is already open, the plugin will try to reconnect, otherwise the connection will be closed.

```csharp
signalRConnection.OnError += (conn, err) => Debug.Log("Error: " + err);
```

- **OnReconnecting**: This event is fired, when a reconnect attempt is started. After this event an OnError or an OnReconnected event is called. Multiple OnReconnecting-OnError event pairs can be fired before an OnReconnected/OnClosed event, because the plugin will try to reconnect multiple times in a given time.

```csharp
signalRConnection.OnReconnecting += (con) => Debug.Log("Reconnecting");
```

- **OnReconnected**: Fired when a reconnect attempt was successful.

```csharp
signalRConnection.OnReconnecting += (con) => Debug.Log("Reconnected");
```

- **OnStateChnaged**: Fired when the connection’s State changed. The event handler will receive both the old state and the new state.

```csharp
signalRConnection.OnStateChanged += (conn, oldState, newState) => Debug.Log(string.Format("State Changed {0} -> {1}", oldState, newState));
```

- **OnNonHubMessage**: Fired when the server send a non-hub message to the client. The client should know what types of messages are expected from the server, and should cast the received object accordingly.

```csharp
signalRConnection.OnNonHubMessage += (con, data) => Debug.Log("Message from server: " + data.ToString());
```

- **RequestPreparator**: This delegate is called for every HTTPRequest that made and will be sent to the server. It can be used to further customize the requests.

```csharp
signalRConnection.RequestPreparator = (con, req, type) => req.Timeout = TimeSpan.FromSeconds(30);
```
