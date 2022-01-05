---
title: Set the default Json encoder
sidebar: best_http2_main_sidebar
---

You can change the default Json encoder by setting the SocketManager’s static DefaultEncoder for a new default. After this step all newly created SocketManager will use this encoder.

```csharp
SocketManager.DefaultEncoder = new LitJsonEncoder();
```

The encoder can be changed for a SocketManager instance too: 
```csharp
var manager = new SocketManager(new Uri("http://.../socket.io/"), options);
manager.Encoder = new LitJsonEncoder();
```