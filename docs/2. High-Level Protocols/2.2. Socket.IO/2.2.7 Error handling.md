#Error handling
An "error" event emitted when a server side or client side error occurs. The first parameter of the event will be an `Error` object. This will contain an error code in the Code property and a string message in the Message property. The `ToString()` function int this class has been overridden, you can use this function to write out its contents.

```csharp
Socket.On(SocketIOEventTypes.Error, OnError);

void OnError(Socket socket, Packet packet, params object[] args)
{
    Error error = args[0] as Error;

    switch (error.Code)
    {
        case SocketIOErrors.User:
            Debug.Log("Exception in an event handler!");
            break;
        case SocketIOErrors.Internal:
            Debug.Log("Internal error!");
            break;
        default:
            Debug.Log("Server error!");
            break;
    }

    Debug.Log(error.ToString());
}
```
