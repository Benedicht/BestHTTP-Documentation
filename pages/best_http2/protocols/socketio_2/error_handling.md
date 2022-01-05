---
title: Error handling
sidebar: best_http2_main_sidebar
---

An "error" event emitted when a server or client side error occurs. The first parameter of the event will be an `Error` object. It contains an error code in its `Code` property and a textual message in its `Message` property. Error overrides its `ToString()` so it can be used to write out its contents.

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
            Debug.Log("Internal error! Message: " + error.Message);
            break;
        default:
            Debug.Log("Server error! Message: " + error.Message);
            break;
    }

	// Or just use ToString() to print out .Code and .Message:
    Debug.Log(error.ToString());
}
```
