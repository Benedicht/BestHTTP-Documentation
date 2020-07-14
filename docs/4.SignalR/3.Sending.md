# Sending non-Hub messages
Sending non-hub messages to the server is easy as calling a function on the connection object:

```language-csharp
signalRConnection.Send(new { Type = "Broadcast", Value = "Hello SignalR World!" });
```

This function will encode the given object to a Json string using the Connection’s JsonEncoder, and sends it to the server.

Already encoded Json strings can be sent using the SendJson function:

```language-csharp
signalRConnection.SendJson("{ Type: ‘Broadcast’, Value: ‘Hello SignalR World!’ }");
```
