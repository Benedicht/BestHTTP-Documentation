#Connecting to namespaces
By default the SocketManager will connect to the root("/") namespace while connecting to the server. You can access it through the SocketManager’s Socket property:

```csharp
Socket root = manager.Socket;
```

Non-default namespaces can be accessed through the GetSocket("/nspName") function or through the manager’s indexer property:

```csharp
Socket nsp = manager["/customNamespace"];
// the same as this method:
Socket nsp = manager.GetSocket("/customNamespace");
```

First access to a namespace will start the internal connection process.
