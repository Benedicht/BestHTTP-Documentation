#How to disable features
There are many defines that can be used to disable various features. These defines can be combined, even all can be set. Disabled features will not compile, so build size can be reduced by disabling unused features. Check the Unity manual how you can set these defines: <http://docs.unity3d.com/Manual/PlatformDependentCompilation.html>

These defines are the following:

- **BESTHTTP_DISABLE_COOKIES**: With this define all cookie related code can be disabled. No cookie parsing, saving and sending will occur.
- **BESTHTTP_DISABLE_CACHING**: With this define all cache related code can be disabled. No caching, or cache validation will be done.
- **BESTHTTP_DISABLE_SERVERSENT_EVENTS**: Server-Sent Events can be disabled with this. SignalR will not fallback to this.
- **BESTHTTP_DISABLE_WEBSOCKET**: Websocket can be disabled with this. SignalR and Socket.IO will not use this protocol.
- **BESTHTTP_DISABLE_SIGNALR**: The entire SignalR implementation will be disabled.
- **BESTHTTP_DISABLE_SIGNALR_CORE**: The SignalR Core implementation will be disabled.
- **BESTHTTP_DISABLE_SOCKETIO**: The entire Socket.IO implementation will be disabled.
- **BESTHTTP_DISABLE_ALTERNATE_SSL**: If you are not using HTTPS(or WSS for WebSocket) and HTTP/2, you can disable the alternate ssl handler.
- **BESTHTTP_DISABLE_HTTP2**: To disable the the HTTP/2 protocol.