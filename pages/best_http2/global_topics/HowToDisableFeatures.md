---
title: Ho to disable features
sidebar: best_http2_main_sidebar
---

There are many defines that can be used to disable various features. These defines can be combined, even all can be set. Disabled features will not compile, so build size can be reduced by disabling unused features. Check the Unity manual how you can set these defines: <https://docs.unity3d.com/Manual/CustomScriptingSymbols.html>

## Available defines

These are the defines that has an effect on the plugin:

- **BESTHTTP_DISABLE_COOKIES**: With this define all cookie related code can be disabled. No cookie parsing, saving and sending will occur.
- **BESTHTTP_DISABLE_COOKIE_SAVE**: With this define cookies remain enabled, only persisting them going to be disabled.
- **BESTHTTP_DISABLE_CACHING**: With this define all cache related code can be disabled. No caching, or cache validation will be done.
- **BESTHTTP_DISABLE_SERVERSENT_EVENTS**: Server-Sent Events can be disabled with this. SignalR will not fallback to this.
- **BESTHTTP_DISABLE_WEBSOCKET**: Websocket can be disabled with this. SignalR and Socket.IO will not use this protocol.
- **BESTHTTP_DISABLE_SIGNALR**: The entire SignalR implementation will be disabled.
- **BESTHTTP_DISABLE_SIGNALR_CORE**: The SignalR Core implementation will be disabled.
- **BESTHTTP_DISABLE_SOCKETIO**: The entire Socket.IO implementation will be disabled.
- **BESTHTTP_DISABLE_ALTERNATE_SSL**: With this the BouncyCastle based TLS handler can be disabled. In the past BouncyCastle was the alternate handler but became the default one because of it can provide features for the plugin through almost all supported platforms. Disabling BouncyCastle has the biggest impact reducing compiled size, but it will disable HTTP/2 too.
- **BESTHTTP_DISABLE_GZIP**: If set, the plugin going to ask for non-compressed data from the server.
- **BESTHTTP_DISABLE_HTTP2**: To disable the HTTP/2 protocol.

## Protocol related defines

* SignalR Core
	- **BESTHTTP_SIGNALR_CORE_ENABLE_GAMEDEVWARE_MESSAGEPACK**
	- **BESTHTTP_SIGNALR_CORE_ENABLE_MESSAGEPACK_CSHARP**
	- **BESTHTTP_SIGNALR_CORE_ENABLE_NEWTONSOFT_JSON_DOTNET_ENCODER**
	
	More can be read about these under the [SignalR Core Encoders](../protocols/signalr_core/Encoders.html) topic.
	
* Socket.IO 3
	- **BESTHTTP_SOCKETIO_ENABLE_GAMEDEVWARE_MESSAGEPACK**
	
	More can be read about these under the [Socket.IO 3 Parsers](../protocols/socketio/socketio.html#parsers) topic.