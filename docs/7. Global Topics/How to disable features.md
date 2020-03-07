# How to disable features
There are many defines that can be used to disable various features. These defines can be combined, even all can be set. Disabled features will not compile, so build size can be reduced by disabling unused features. Check the Unity manual how you can set these defines: <http://docs.unity3d.com/Manual/PlatformDependentCompilation.html>

## Available defines

These are the defines that has an effect on the plugin:

- **BESTHTTP_DISABLE_COOKIES**: With this define all cookie related code can be disabled. No cookie parsing, saving and sending will occur.
- **BESTHTTP_DISABLE_CACHING**: With this define all cache related code can be disabled. No caching, or cache validation will be done.
- **BESTHTTP_DISABLE_SERVERSENT_EVENTS**: Server-Sent Events can be disabled with this. SignalR will not fallback to this.
- **BESTHTTP_DISABLE_WEBSOCKET**: Websocket can be disabled with this. SignalR and Socket.IO will not use this protocol.
- **BESTHTTP_DISABLE_SIGNALR**: The entire SignalR implementation will be disabled.
- **BESTHTTP_DISABLE_SIGNALR_CORE**: The SignalR Core implementation will be disabled.
- **BESTHTTP_DISABLE_SOCKETIO**: The entire Socket.IO implementation will be disabled.
- **BESTHTTP_DISABLE_ALTERNATE_SSL**: If you are not using HTTPS(or WSS for WebSocket) and HTTP/2, you can disable the alternate ssl handler.
- **BESTHTTP_DISABLE_GZIP**: If set, the plugin going to ask for non-compressed data from the server.
- **BESTHTTP_DISABLE_HTTP2**: To disable the HTTP/2 protocol.

## Protocol related defines

* SignalR Core
	- **BESTHTTP_SIGNALR_CORE_ENABLE_GAMEDEVWARE_MESSAGEPACK**
	- **BESTHTTP_SIGNALR_CORE_ENABLE_NEWTONSOFT_JSON_DOTNET_ENCODER**
	
	More can be read about these under the [SignalR Core Encoders](../6. SignalR Core/Encoders.md) topic