# SocketIO

The Socket.IO implementation uses features that the plugin already have. It will send `HTTPRequest`s to get the handshake data, sending and receiving packets when the polling transport is used with all of its features(cookies, connection reuse, etc.). And the `WebSocket` implementation is used for the `WebSocket` transport.

Brief feature list of this Socket.IO implementation:

- Easy to use and familiar api
- Compatible with the latest Socket.IO specification
- Seamless upgrade from polling transport to websocket transport
- Automatic reconnect on disconnect
- Easy and efficient binary data sending and multiple ways of receiving
- Powerful tools to use it in an advanced mode(switch the default encoder, disable auto-decoding, etc.)

If you want to connect to a Socket.IO service you can do it using the BestHTTP.SocketIO.SocketManager class. First you have to create a SocketManager instance:

```language-csharp
using System;
using BestHTTP;
using BestHTTP.SocketIO;

var manager = new SocketManager(new Uri("https://socket-io-chat.now.sh/socket.io/"));
```

!!! Notice
	The */socket.io/* path in the url is very important, by default the Socket.IO server will listen on this query. So don’t forget to append it to your test url too!
	
## Socket.IO 3 support

Engine.IO v4 and Socket.IO v3 changed the underlying protocol and behavior in a non backward compatible way. The plugin tries its best to handle both the old versions and the new seamlessly but it's not possible for every use-case. If the server version is known it's the best to set `SocketOptions`' `ServerVersion`:

```language-csharp
SocketOptions options = new SocketOptions();
options.ServerVersion = SupportedSocketIOVersions.v3;

var manager = new SocketManager(new Uri("http://localhost:3000/socket.io/"), options);
```

The plugin also implements the new authentication support of v3, where a json payload can be sent with the first namespace connect packet:

```language-csharp
SocketOptions options = new SocketOptions();
// Auth works only with Socket.IO v3
options.ServerVersion = SupportedSocketIOVersions.v3;

options.Auth = (socketManager, socket) => LitJson.JsonMapper.ToJson(new { token = 123 });

var manager = new SocketManager(new Uri("http://localhost:3000/socket.io/"), options);
```

On the server the authentication payload can be accessed throgh `socket.handshake.auth`:

```language-csharp
io.on('connection', (socket) => {
    console.log(socket.id + ' connected! auth: ' + JSON.stringify(socket.handshake.auth));
});
```