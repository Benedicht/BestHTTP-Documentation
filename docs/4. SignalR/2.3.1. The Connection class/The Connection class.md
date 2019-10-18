#The Connection class
The Connection class from the BestHTTP.SignalR namespace manages an abstract connection to the SignalR server. Connecting to a SignalR server start with the creation of a Connection object.
This class will keep track of the current state of the protocol and will fire events.

You can create a Connection object multiple ways:

```csharp
using BestHTTP.SignalR;

Uri uri = new Uri("http://besthttpsignalr.azurewebsites.net/raw-connection/");
```

- Create the connection, without Hubs by passing only the server’s uri to the constructor.

```csharp
Connection signalRConnection = new Connection(uri);
```

-  Create the connection, with Hubs by passing the hub names to the constructor too.

```csharp
Connection signalRConnection = new Connection(uri, "hub1", "hub2", "hubN");
```

-  Create the connection, with Hubs by passing Hub objects to the constructor.

```csharp
Hub hub1 = new Hub("hub1");
Hub hub2 = new Hub("hub2");
Hub hubN = new Hub("hubN");
Connection signalRConnection = new Connection(uri, hub1, hub2, hubN);
```

You can’t mix options 2 and 3.

After we created the Connection, we can start to connect to the server by calling the Open() function on it:

```csharp
signalRConnection.Open();
```
