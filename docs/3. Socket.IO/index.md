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

The /socket.io/ path in the url is very important, by default the Socket.IO server will listen on this query. So don’t forget to append it to your test url too!