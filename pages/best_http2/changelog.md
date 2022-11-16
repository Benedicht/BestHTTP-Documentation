---
title: Changelog
sidebar: best_http2_main_sidebar
---

## 2.8.0 (2022-11-16)

**General**

- [<span style="color:green">New Feature</span>] Experimental [automatic proxy detection](global_topics/Proxy.html#automatic-proxy-detection)
- [<span style="color:blue">Improvement</span>] Do not build proxy related code into WebGL builds.
- [<span style="color:blue">Improvement</span>] Increased `BufferPool.MaxPoolSize` to 20Mb.
- [<span style="color:red">Bugfix</span>] Fixed case where a TCP connection might remain open.

**TLS**

- [<span style="color:blue">Improvement</span>] Updated BouncyCastle to the latest version.
- [<span style="color:red">Bugfix</span>] Fixed [Issue-123](https://github.com/Benedicht/BestHTTP-Issues/issues/123) (TLS decoding fails with *bad_record_mac* error).

**HTTP**

- [<span style="color:green">New Feature</span>] [Issue-125](https://github.com/Benedicht/BestHTTP-Issues/issues/125) Support added for Brotli compression under Unity 2021.2 or newer builds.
- [<span style="color:blue">Improvement</span>] Maximize download/upload events to one per frame to reduce overhead when slow framerate combined with hight download/upload events.

**WebSocket**

- [<span style="color:green">New Feature</span>] New `SendAsBinary` and `SendAsText` implementation to send `BufferSegment`s.
- [<span style="color:blue">Improvement</span>] Moved data fragmentation and extension negotiation to the send thread zeroing any overhead calling many `Send` method when sending large amount of data.
- [<span style="color:blue">Improvement</span>] Reduced the number of data copying.
- [<span style="color:blue">Improvement</span>] Masking the payload now can proccess 8 bytes per cycle instead of 4 bytes.

**SignalR Core**

- [<span style="color:green">New Feature</span>] Support added for [Server callable client functions](protocols/signalr_core/HubConnection.html#server-callable-client-functions).
- [<span style="color:blue">Improvement</span>] Reduced the number of data copying with the websocket transport.

**SocketIO 3+**

- [<span style="color:blue">Improvement</span>] Reduced the number of data copying with the websocket transport.
- [<span style="color:blue">Improvement</span>] MsgPackParser to try to avoid a lot of memory copy when used with large payloads, it computes an average payload length and allocates memory based on this instead of a fixed smaller value.
- [<span style="color:red">Bugfix</span>] Fixed case where callbacks added with `ExpectAcknowledgement` didn't called when the sent data contained binary.

## 2.7.0 (2022-08-25)

**General**

- [<span style="color:green">New Feature</span>] [Issue-115](https://github.com/Benedicht/BestHTTP-Issues/issues/115) `HTTPManager.SetThreadingMode` implementation. 
- [<span style="color:green">New Feature</span>] Added new `QUERY` http method.
- [<span style="color:red">Bugfix</span>] `LoggingContext` now should generate a more unique hash for objects it's bound to, generating less confusing verbose logs.
- [<span style="color:red">Bugfix</span>] [Issue-117](https://github.com/Benedicht/BestHTTP-Issues/issues/117) Fixed compile errors when `BESTHTTP_DISABLE_PROXY` or `BESTHTTP_DISABLE_CACHING` are defined.

**TLS**

- [<span style="color:green">New Feature</span>] Encrypt/decrypt performance now can be improved with [Burst](https://docs.unity3d.com/Manual/com.unity.burst.html)! See the [HTTPS documentation](global_topics/HTTPS.html#boost-tls-encryptdecrypt-performance-with-burst) for more info.
- [<span style="color:blue">Improvement</span>] Removed Il2CppSetOptions as they are not improved the performance as aticipated while they added some risk for runtime errors.
- [<span style="color:red">Bugfix</span>] Fixed race condition between `ReadApplicationData` and `TestApplicationData` calls.
- [<span style="color:red">Bugfix</span>] [TLS 1.3] Send CertificateRequestContext with the client certificate.

**HTTP/1**

- [<span style="color:red">Bugfix</span>] [Issue-114](https://github.com/Benedicht/BestHTTP-Issues/issues/114) Store headers as received

**HTTP/2**

- [<span style="color:blue">Improvement</span>] HTTP/2 stream will not send a window-update frame if received all data.
- [<span style="color:blue">Improvement</span>] Maximized memory allocation to `HTTPRequest.UploadChunkSize` when uploading content instead of the remote server's `MAX_FRAME_SIZE` settings as it can be quite large.

**SocketIO 3+**

- [<span style="color:red">Bugfix</span>] [MsgPackParser] will send null parameters correctly.

**WebSocket**

- [<span style="color:green">New Feature</span>] [ISSUE-116](https://github.com/Benedicht/BestHTTP-Issues/issues/116) [OnBinaryNoAlloc](protocols/websocket/websocket.html#onbinarynoalloc) implementation. Receive binary messages without memory allocations!
- [<span style="color:blue">Improvement</span>] [ISSUE-116](https://github.com/Benedicht/BestHTTP-Issues/issues/116) If there's no subscriber for the `OnBinary` event, no memory allocations will be made.

**SignalR Core**

- [<span style="color:red">Bugfix</span>] Fix for `"Missing required property 'type'"` errors caused by Managed Code Stripping.

## 2.6.3 (2022-07-07)

**General**

- [<span style="color:green">New Feature</span>] Added `HTTPUpdateDelegator.SwapThreadingMode()` function to switch between threaded and Unity's main thread mode.
- [<span style="color:red">Bugfix</span>] In some cases ReadOnlyBufferedStream blocked indefinitely until new data arrived.
- [<span style="color:blue">Improvement</span>] TcpClient will try to connect to IPv4 addresses first.

**HTTP**

- [<span style="color:red">Bugfix</span>] Don't send a Content-Length (: 0) header if there's an Upgrade header. Upgrade is set for websocket, and it might be not true that the client doesn't send any bytes.
- [<span style="color:red">Bugfix</span>] Set Exception to null on Send() and Clear() calls
- [<span style="color:blue">Improvement</span>] Added status code 303 as redirect code.

**SocketIO 3+**

- [<span style="color:red">Bugfix</span>] [MsgPackParser] no longer throws an exception after parsing an event that the client doesn't subscribed to.
- [<span style="color:blue">Improvement</span>] Websocket transport will send pings using its default setting.

**SignalR Core**

- [<span style="color:red">Bugfix</span>] Fixed case where the protocol tried to reconnect while the application is quitting.
- [<span style="color:red">Bugfix</span>] Fix for a case where the application is in the background and the (websocket) connection is closed, bringing the app foreground processes other messages (pings for example) first and errors out tring to send an answer instead of processing the close frame instead.
- [<span style="color:red">Bugfix</span>] Fixed case where rwLock dispose code might execute while calling transport. Send in SendMessage, while holding the lock.
- [<span style="color:blue">Improvement</span>] Websocket transport will send pings using its default setting.

**Websocket**

- [<span style="color:blue">Improvement</span>] Ping-pong mechanism moved to the sender thread, so a websocket connection will be kept alive in the background until threads are executed.

## 2.6.2 (2022-04-18)

**TLS**

- [<span style="color:red">Bugfix</span>] SslStream instance not set when HTTPManager.ClientCertificationProvider is null.

**General**

- [<span style="color:red">Bugfix</span>] [WebGL] Fixed tangling with unity's webrequest module
- [<span style="color:blue">Improvement</span>] [LitJson] Don't try to set a dictionary's property, add it as an element instead.
- [<span style="color:blue">Improvement</span>] Add logging when connecting to an address.
- [<span style="color:blue">Improvement</span>] Added warning for cases where the LastProcessedUri of the connectionEvent's Srouce is null.

**SocketIO 3+**

- [<span style="color:blue">Improvement</span>] Set options.ConnectWith to TransportTypes.WebSocket when the uri's scheme starts with wss/ws

## 2.6.1 (2022-03-17)

**General**

- [<span style="color:blue">Improvement</span>] Lowered the logging severity of `RemoveConnection - Couldn't find connection!` warning string.
- [<span style="color:red">Bugfix</span>] Fixed compile error when BESTHTTP_DISABLE_ALTERNATE_SSL is used.
- [<span style="color:red">Bugfix</span>] Fixed compile error when BESTHTTP_DISABLE_COOKIES is used.

**HTTP/2**

- [<span style="color:blue">Improvement</span>] Lowered the logging severity of `Skipping data sending as remote Window is ...` warning string.

**SignalR Core**

- [<span style="color:red">Bugfix</span>] `MessagePackCSharpProtocol` now uses `MessagePackSerializer`'s IL2CPP friendly serialization/deserialization.

## 2.6.0 (2022-03-03)

This release contains breaking changes, check out the [Upgrade Guide](UpgradeGuide.html#upgrade-from-2x-to-26) for help.

**TLS**

- [<span style="color:green">New Feature</span>] Migrated to BouncyCastles's new TLS api
- [<span style="color:green">New Feature</span>] Added support for **TLS 1.3**, the supported minimum TLS version is now **TLS 1.2**
- [<span style="color:green">New Feature</span>] Added support for Server-initiated TLS renegotiation
- [<span style="color:green">New Feature</span>] Before choosing a free connection from the pool, the connection going to be tested. If the server sent a TLS alert notify of closing the connection, the plugin also closes the pooled connection and not going to try to use it.
- [<span style="color:blue">Improvement</span>] Removed TLS related functions and properties from the HTTPRequest
- [<span style="color:blue">Improvement</span>] More memory allocation optimizations
- [<span style="color:blue">Improvement</span>] Removed the now unused crypto/tls folder

**General**

- [<span style="color:blue">Improvement</span>] `HTTPRequest`'s `OnHeadersReceived` now receives the headers as its parameter. This way regular and trailing headers can be distinguish.
- [<span style="color:blue">Improvement</span>] Added logging with context to Connection, Protocol and Plugin events.
- [<span style="color:blue">Improvement</span>] When a `HTTPRequest`'s `IsKeepAlive` is set to `false` and a new connection would open, the plugin not going to try to negotiate a HTTP/2 connection as it would be kept open even longer.
- [<span style="color:blue">Improvement</span>] Removed WebGL specific IO service implementation as it's uses the default one since v2.5.3

**HTTP/1**

- [<span style="color:red">Bugfix</span>] Fixed case where redirecting and closing the connection resulted in only redirecting the request but the connection stayed open.

**HTTP/2**

- [<span style="color:green">New Feature</span>] `HTTP2PluginSettings` has a new `Timeout` field: the time to wait for a pong answer from the server before treating the connection as broken.
- [<span style="color:blue">Improvement</span>] When the `HTTPRequest`'s `IsKeepAlive` is set to false, the plugin not going to try to negotiate a HTTP/2 connection as it would kept alive no matter what's the value of the initiator `HTTPRequest`'s `IsKeepAlive`.
- [<span style="color:blue">Improvement</span>] Lowered `HTTP2PluginSettings.PingFrequency` to send out ping requests more frequently.
- [<span style="color:red">Bugfix</span>] Don't send 'proxy-' headers with the request
- [<span style="color:red">Bugfix</span>] [[ISSUE-85](https://github.com/Benedicht/BestHTTP-Issues/issues/85)] HPACK encoder's DecodeString didn't handled the case where the string length is 0

**SocketIO 3+**

- [<span style="color:blue">Improvement</span>] Improved debug logging of outgoing packets

**SignalR Core**

- [<span style="color:green">New Feature</span>] [[ISSUE-82](https://github.com/Benedicht/BestHTTP-Issues/issues/82)] [Added support](https://benedicht.github.io/BestHTTP-Documentation/pages/best_http2/protocols/signalr_core/Encoders.html#messagepack-csharp) for [neuecc/MessagePack-CSharp](https://github.com/neuecc/MessagePack-CSharp)
- [<span style="color:red">Bugfix</span>] [[ISSUE-85](https://github.com/Benedicht/BestHTTP-Issues/issues/87)] Calling `StartClose` more than twice resulted in a `NullReferenceException`.
- [<span style="color:red">Bugfix</span>] [[ISSUE-84](https://github.com/Benedicht/BestHTTP-Issues/issues/84)] Call `Clear` on `triedoutTransports` when reconnecting.
 
**WebSocket**

- [<span style="color:red">Bugfix</span>] [**WebGL**] [[ISSUE-88](https://github.com/Benedicht/BestHTTP-Issues/issues/88)] Fixed case where sending textual message containing `null`(`\0`) characters failed because [Emscripten's UTF8ToString](https://emscripten.org/docs/api_reference/preamble.js.html#UTF8ToString) expects a null-terminated string and doesn't include it in the final string.
 
## 2.5.4 (2021-12-27)

**General**

- [<span style="color:red">Bugfix</span>] Call ResetSetups only when run in the editor
- [<span style="color:red">Bugfix</span>] [[ISSUE-77](https://github.com/Benedicht/BestHTTP-Issues/issues/77)] Potential managed memory leak with HTTP2Stream disposal
- [<span style="color:red">Bugfix</span>] `ThreadedLogger`: Empty cached StringBuilder on thread exit
- [<span style="color:blue">Improvement</span>] Improved compatibility with High Managed Stripping Level
- [<span style="color:blue">Improvement</span>] Added a new log entry when a new request event is added to the event queue
- [<span style="color:blue">Improvement</span>] Removed per-field content-length header from the multipart/form-data implementations

**TLS**

- [<span style="color:blue">Improvement</span>] Updated BouncyCastle to the latest version

**SocketIO 3+**

- [<span style="color:red">Bugfix</span>] Fixed client acknowledgment sending

**SignalR Core**

- [<span style="color:blue">Improvement</span>] Send and invoke functions are now thread safe
- [<span style="color:blue">Improvement</span>] Subscribing to a server-sent event now throws and exception if the connection's state is equal or larger than CloseInitiated

**Examples**

- [<span style="color:red">Bugfix</span>] Fixed BufferPoolMemoryStream usage in MultipartFormDataStream
- [<span style="color:red">Bugfix</span>] Change root sample url
- [<span style="color:blue">Improvement</span>] Changed the WebSocket demo's url to a working one

## 2.5.3 (2021-10-18)

**General**

- [<span style="color:red">Bugfix</span>] Fixed race condition in the timing api that could result in an exception
- [<span style="color:red">Bugfix</span>] Resend request with proxy authtentication header when it's a transparent proxy. Possible workaround for waiting for chunked encoded proxy response
- [<span style="color:red">Bugfix</span>] Possible fix of a race condition in the `BufferPool` implementation
- [<span style="color:red">Bugfix</span>] [[ISSUE-75]](https://github.com/Benedicht/BestHTTP-Issues/issues/75) HTTP2Response uses int for contentLength instead of long so doesn't track large (2.1GB+) files
- [<span style="color:blue">Improvement</span>] Dispose implementation overhaul
- [<span style="color:blue">Improvement</span>] Added support for relative redirect urls
- [<span style="color:blue">Improvement</span>] Logging out a BufferSegment now going to log out (part of) the data too
- [<span style="color:blue">Improvement</span>] [WebGL] Add Set-Cookie header only when its value isn't empty
- [<span style="color:blue">Improvement</span>] [WebGL] Use the default IO service under WebGL too, but explicitly disable the caching service and cookie saving
- [<span style="color:blue">Improvement</span>] Removed non-used ConcurrentStack file
- [<span style="color:blue">Improvement</span>] Don't keep an HTTP1 connection in the connection pool if the last processed request/response returned max=0 in a Keep-Alive header

**SignalR Core**

- [<span style="color:red">Bugfix</span>] [Long-Polling transport] Removed fake ping message as it's triggered a client-sent one, that triggered a new fake one, etc.
- [<span style="color:blue">Improvement</span>] [MessagePackProtocol] Added support for parameterless callbacks

**Websocket**

- [<span style="color:red">Bugfix</span>] [Long-Polling transport] Use WebSocket's `MaxFragmentSize` in WebSocketResponse

**Socket.IO 3**

- [<span style="color:red">Bugfix</span>] Call Dispose on `StringReaders`

## 2.5.2 (2021-08-02)

**General**

- [<span style="color:red">Bugfix</span>] Moved documentation from readthedocs to github pages
- [<span style="color:red">Bugfix</span>] [WebGL] In some cases XHR_Send called twice
- [<span style="color:blue">Improvement</span>] Return early if base request is cancelled instead of throwing an exception
- [<span style="color:blue">Improvement</span>] Change TCP Client's buffer sizes only when a custom value is set in the HTTPManager
- [<span style="color:blue">Improvement</span>] Sample URL changes

**HTTP/2**

- [<span style="color:red">Bugfix</span>] Possible bugfix for a case where Process is called for a request while the handler already shutting down resulting in a NullRef. exception
- [<span style="color:red">Bugfix</span>] GOAWAY frame's additional data read from the wrong position of the buffer

**SignalR Core**

- [<span style="color:blue">Improvement</span>] Append access_token query param only if there's a negotiated access token
- [<span style="color:red">Bugfix</span>] Set connectionStartedAt on a reconnect attempt too to avoid an outdated value cancelling authentication requests

**SocketIO 3**

- [<span style="color:blue">Improvement</span>] [Default Json parser] Catch and log exception when doing ReadParameters

## 2.5.1 (2021-05-28)

**General**

- [<span style="color:red">Bugfix</span>] Disabled strack trace collection for BufferPool releases

**HTTP/2**

- [<span style="color:red">Bugfix</span>] First request over HTTP/2 doesn't set ProcessingStarted

**SocketIO 3**

- [<span style="color:red">Bugfix</span>] [MsgPackParser] Skip object reading when there's no OnError subscriber

## 2.5.0 (2021-05-17)

**Websocket**

- [<span style="color:green">New Feature</span>] New [Websocket Over HTTP/2 implementation](protocols/websocket/advanced.html#implementations)

**General**

- [<span style="color:blue">Improvement</span>] Added log when the DNS query is finished
- [<span style="color:blue">Improvement</span>] Buffer improvements
- [<span style="color:red">Bugfix</span>] More Unity DateTime locale bug workaround

**SocketIO 3**

- [<span style="color:red">Bugfix</span>] Fixed emitting to custom namespaces
- [<span style="color:red">Bugfix</span>] Default namespace not going to be opened by default

**SignalR Core**

- [<span style="color:blue">Improvement</span>] Added vector serializers compatible with Neuecc's MessagePack implementation
- [<span style="color:red">Bugfix</span>] Cancel and clear (async) invocations when the connection is closed
- [<span style="color:red">Bugfix</span>] Fixed case where reconnecting opened more connections 

## 2.4.0 (2021-03-18)

**General**

- [<span style="color:blue">Improvement</span>] Threads are now started as background threads
- [<span style="color:blue">Improvement</span>] Reworked HTTPRequest timeout handling, now callbacks are called almost instantly.
- [<span style="color:blue">Improvement</span>] Moved LitJson to the source folder instead of the examples, now it's under the BestHTTP.JSON namespace.
- [<span style="color:red">Bugfix</span>] [ISSUE-53](https://github.com/Benedicht/BestHTTP-Issues/issues/53) Redirect fails when UriBuilder escapes query string in the redirect location

**Socket.IO 3**

- [<span style="color:green">New Feature</span>] A [new Socket.IO implementation](protocols/socketio/socketio.html) for Socket.IO 3 with [strongly typed callbacks](protocols/socketio/socketio.html#subscribing-to-events)!
- [<span style="color:green">New Feature</span>] New parser interface to be able to implement parsers other than json
- [<span style="color:green">New Feature</span>] New [MsgPackParser](protocols/socketio/socketio.html#parsers)
- [<span style="color:blue">Improvement</span>] [Improved documentation](protocols/socketio/socketio.html)

**SignalR Core**

- [<span style="color:red">Bugfix</span>] [Long-Polling Transport] stream got disposed while the transport tried to reuse it
- [<span style="color:blue">Improvement</span>] Introduced `MessagePackProtocolSerializationOptions` to be able to change how enums are serialized

**EventSource**

- [<span style="color:red">Bugfix</span>] [WebGL] Call Close on the browser's EventSource object to prevent its autmatic reconnection

**HTTP**

- [<span style="color:blue">Improvement</span>] [WebGL] `UploadStream` is now going to be uploaded too.

## 2.3.2 (2021-01-06)

**TLS**

- [<span style="color:green">New Feature</span>] [TLS Security Addon](https://assetstore.unity.com/packages/tools/network/best-http-2-tls-security-addon-184441?aid=1101lfX8E) is now available!
- [<span style="color:red">Bugfix</span>] Disabled chacha20-poly1305-04 as it seems it has a data corruption bug
- [<span style="color:blue">Improvement</span>] Improved compatibility with other TLS handlers by not aborting the TLS connection if the server sends back an encrypt-then-mac extension when a non blockcipher is selected

**General**

- [<span style="color:red">Bugfix</span>] Start to count down for a request's timeout when a HTTP1 or 2 handler picks it for processing
- [<span style="color:red">Bugfix</span>] Caching discarded entities when it has only Cache-Control header with a max-age directive
- [<span style="color:blue">Improvement</span>] An already finished but waiting for processing its callback not going to be aborted by a timeout or direct Abort call
- [<span style="color:blue">Improvement</span>] When wrapping an Exception, AsyncHTTPException's message is going to be the exception's message

**SocketIO**

- [<span style="color:red">Bugfix</span>] Fixed various issues around custom namespaces

**SignalR Core**

- [<span style="color:blue">Improvement</span>] Send back a ping message if the client received one from the server

## 2.3.1 (2020-12-14)

**General**

- [<span style="color:red">Bugfix</span>] Enable cookies in the editor when the WebGL platform is selected
- [<span style="color:red">Bugfix</span>] Redirect to the same url is now breaks out from the redirect cycle
- [<span style="color:blue">Improvement</span>] `DateTime` logging changes to workaround a possible Unity issue
- [<span style="color:blue">Improvement</span>] Fixed `HeaderParser` compatibility with non-conformant headers
- [<span style="color:blue">Improvement</span>] `HeaderParser` is now used to determine whether a response is cachable to use less cpu and memory
- [<span style="color:blue">Improvement</span>] `HTTPRequest`'s MaxRedirects' default is now 10

**HTTP/2**

- [<span style="color:blue">Improvement</span>] Send ENABLE_PUSH = 0 settings to the server

**SocketIO**

- [<span style="color:red">Bugfix</span>] The correct EIO version is sent now with the requests
- [<span style="color:blue">Improvement</span>] Changed socket notification about transport open to reduce overhead

**Websocket**

- [<span style="color:blue">Improvement</span>] Don't log error on application quit

## 2.3.0 (2020-11-23)

**General**

- [<span style="color:green">New Feature</span>] New [`Exceptions`](global_topics/Proxy.md#add-exceptions) property for proxies to be able to skip proxy for specified hosts
- [<span style="color:red">Bugfix</span>] LitJson dictionary (object) instantiation fix
- [<span style="color:red">Bugfix</span>] HeartbeatManager wasn't cleared on application quit

**SocketIO**

- [<span style="color:green">New Feature</span>] Support for [Socket.IO 3](https://socket.io/blog/socket-io-3-release/)
- [<span style="color:green">New Feature</span>] New `ServerVersion` option that can be set if the server's Socket.IO version is known
- [<span style="color:green">New Feature</span>] New `Auth` function to send payload while connecting to a namespace (only with Socket.IO 3)
- [<span style="color:red">Bugfix</span>] Fixed an issue where reconnection failed if there were an upgrading transport while waiting for reconnect countdown

**Websocket**

- [<span style="color:red">Bugfix</span>] Fixed typo in `CloseAfterNoMesssage`

**SignalR Core**

- [<span style="color:green">New Feature</span>] Added CancellationToken support for `InvokeAsync` and `SendAsync`

## 2.2.2 (2020-10-22)

**Websocket**

- [<span style="color:red">Bugfix</span>] ServerNoContextTakeover is set to the wrong value in the PerMessageCompression constructor

**WebGL**

- [<span style="color:red">Bugfix</span>] Fixed case where the response got corrupted

## 2.2.1 (2020-10-20)

**TLS**

- [<span style="color:green">New Feature</span>] Added new `HTTPManager.TlsClientFactory` callback to be able to provide custom Tls clients
- [<span style="color:blue">Improvement</span>] `X509Name` going to cache ToString result
- [<span style="color:red">Bugfix</span>] SendCertificateVerifyMessage logged different function name

**General**

- [<span style="color:blue">Improvement</span>] Made `HTTPManager.GetRootCacheFolder()` public instead of internal
- [<span style="color:blue">Improvement</span>] Switched to all-yellow logging color
- [<span style="color:blue">Improvement</span>] Renamed `FileStreamModes.Open` to `OpenRead` and added new `OpenReadWrite`
- [<span style="color:blue">Improvement</span>] `ThreadedLogger`'s thread is now named
- [<span style="color:blue">Improvement</span>] Added `ExitThreadAfterInactivity` to `ThreadedLogger`
- [<span style="color:red">Bugfix</span>] Fixed example prefab ([ISSUE-36](https://github.com/Benedicht/BestHTTP-Issues/issues/36))
- [<span style="color:red">Bugfix</span>] New `Queued` HTTPRequest state for possible double send fix ([ISSUE-38](https://github.com/Benedicht/BestHTTP-Issues/issues/38))

**HTTP/1**

- [<span style="color:blue">Improvement</span>] Request will send [Keep-Alive header](https://tools.ietf.org/html/draft-thomson-hybi-http-timeout-03) to the server to let them know about the client setting

**HTTP/2**

- [<span style="color:red">Bugfix</span>] Fixed a possible infinite loop when `HTTP2FrameHelper`'s `StreamRead` had to read zero bytes, or when the TCP stream is got closed and stream.Read returns zero
- [<span style="color:blue">Improvement</span>] Removed a few unnecessary instructions from buffer processing

**Websocket**

- [<span style="color:blue">Improvement</span>] Lowered `CloseAfterNoMesssage`'s default value to 2 seconds
- [<span style="color:red">Bugfix</span>] Buffer used to masking the frame released back to the BufferPool before the masking itself, resulting in a possible frame corruption
- [<span style="color:red">Bugfix</span>] Set the websocket's state to Closed on http request error
- [<span style="color:red">Bugfix</span>] Removed PingFrequency from timeout calculation

**SignalR Core**

- [<span style="color:red">Bugfix</span>] Fixed issue where calling close on an initial hub connection doesn't lose the connection (and no close callbacks are called either)

**SocketIO**

- [<span style="color:red">Bugfix</span>] Added missing documentation about `SocketOptions`' `AdditionalQueryParams`

**WebGL**

- [<span style="color:red">Bugfix</span>] Switch to use the URL class to avoid possible escaping issues
- [<span style="color:blue">Improvement</span>] Response handling speedup by not copying response body


## 2.2.0 (2020-09-02)

**TLS**

- [<span style="color:blue">Improvement</span>] Bouncy Castle optimizations: depending on the negotiated ciphers download speed can increase and memory hungry parts are also rewritten to use the plugin's [BufferPool](global_topics/BufferPool.md) to decrease GC usage. As parts of the optimizations now the plugin requires the "Allow 'unsafe' Code" to be set
- [<span style="color:blue">Improvement</span>] Added the use of [Encrypt-then-MAC (RFC 7366)](https://tools.ietf.org/html/rfc7366) extension
- [<span style="color:blue">Improvement</span>] Added [ChaCha20-Poly1305 (RFC 7905](https://tools.ietf.org/html/rfc7905) ciphers to the client offered cipher suites to negotiate with the server
- [<span style="color:blue">Improvement</span>] Moved read buffer to the lowest level to reduce context switching when TLS is used, halving reads per TLS message
- [<span style="color:blue">Improvement</span>] Removed an optional error throwing to follow browser behavior

**General**

- [<span style="color:green">New Feature</span>] New [Timing API](protocols/http/Timing.md) to measure when request processing spent most of its time
- [<span style="color:blue">Improvement</span>] Changed thread names for HTTP/1 and HTTP/2 threads so they can be identified in the profiler
- [<span style="color:blue">Improvement</span>] Renamed confusing *"Remote server closed the connection before sending response header!"* exception text
- [<span style="color:blue">Improvement</span>] IL2CPP optimizations by adding and using `Il2CppSetOptionAttribute` and `Il2CppEagerStaticClassConstructionAttribute`
- [<span style="color:blue">Improvement</span>] Added more places to check request cancellation reducing time requirement in some cases to call the request's callback
- [<span style="color:red">Bugfix</span>] Fixed compile errors when BESTHTTP_DISABLE_CACHING and/or BESTHTTP_DISABLE_COOKIES is used
- [<span style="color:red">Bugfix</span>] Fixed a bug where an exception thrown while connecting treated as ConnectionTimedOut
- [<span style="color:red">Bugfix</span>] When the underlying stream has no more data, `ReadOnlyBufferedStream` now returns with the value (0 or -1) the stream returned with
- [<span style="color:red">Bugfix</span>] Fixed compile error using the old runtime
- [<span style="color:red">Bugfix</span>] Dispose a ManualResetEvent used in DNS querying
- [<span style="color:red">Bugfix</span>] Test token.IsCancellationRequested before calling final async logic

**HTTP/1**

- [<span style="color:blue">Improvement</span>] Use the lower value when server provided keep-alive timeout is available. Timeout is set lower then what sent to be more resistant to lag
- [<span style="color:red">Bugfix</span>] With chunked encoding and gzip combined, when the last chunk contained only the gzip trail or parts of it it got truncated and thrown an exception
- [<span style="color:red">Bugfix</span>] Fixed bug where redirection occured to the same host while also receiving a Connection: Close header&value resulted in the reuse of the closing connection

**HTTP/2**

- [<span style="color:blue">Improvement</span>] Suspending a http/2 session's worker thread now going to take account for the disconnect time too.
- [<span style="color:blue">Improvement</span>] Preliminary support for [RFC 8441](https://tools.ietf.org/html/rfc8441)
- [<span style="color:blue">Improvement</span>] Yandex.ru returned with a FLOW_CONTROL_ERROR(3) error when the plugin tried to set the connection window to the RFC defined maximum (2^31 - 1 bytes). Reducing the default by 10 Mib is sufficent.
- [<span style="color:red">Bugfix</span>] Various frames' data didn't release back to the BufferPool
- [<span style="color:red">Bugfix</span>] Ignore RST_STREAM frame when received for a stream with CLOSED state
- [<span style="color:red">Bugfix</span>] Server's initial window size change wasn't handled possibly limiting upload speed
- [<span style="color:red">Bugfix</span>] The plugin expected at least 1 byte of data for frames where padding is available corrupting downloaded data where the server inserts frames where only padding is present
- [<span style="color:red">Bugfix</span>] Fixed a case where the server sent a HTTP/2 GOAWAY frame caused request(s) to get aborted twice

**SignalR**

- [<span style="color:blue">Improvement</span>] Moved unnecessary logging behind a log level check

**SignalR Core**

- [<span style="color:blue">Improvement</span>] Added support to be able to serialize floats.

**SocketIO**

- [<span style="color:green">New Feature</span>] [[ISSUE-25](https://github.com/Benedicht/BestHTTP-Issues/issues/25)] HTTPRequestCustomizationCallback implementation

**Websocket**

- [<span style="color:blue">Improvement</span>] Made the `WebSocketResponse`'s `MaxFragmentSize` public and changed its type to int. Now it can be accessed and modified on non-WebGL platforms

## 2.1.0 (2020-06-29)

**General**

- [<span style="color:green">New Feature</span>] Structured logging to be able to better track parallel requests.
- [<span style="color:green">New Feature</span>] New threaded logger.
- [<span style="color:green">New Feature</span>] New logging model to support output selection (file, unity's Debug.log, etc.) without changing the logger.
- [<span style="color:blue">Improvement</span>] New [`AsyncHTTPException`](protocols/http/Async-await.md#handling-errors) added to be able to access the Status Code of the server's response.
- [<span style="color:blue">Improvement</span>] The HTTPUpdateDelegator going to be hidden in the inspector
- [<span style="color:blue">Improvement</span>] [HTTPManager's IsQuitting](global_topics/GlobalSettings.md) is now public
- [<span style="color:blue">Improvement</span>] A few functions in the `HTTPCacheService` and `HTTPCacheFileInfo` became public.
- [<span style="color:blue">Improvement</span>] Textures loaded through HTTPResponse's DataAsTexture now going to be marked as non-readable.
- [<span style="color:blue">Improvement</span>] Made public all EventHelper classes (in the BestHTTP.Core namespace) to be able to subscribe to OnEvent callbacks.
- [<span style="color:blue">Improvement</span>] Added *Third-Party Notices.txt* and a [similar entry](ThirdPartyNotices.md) in the documentation.
- [<span style="color:red">Bugfix</span>] [[ISSUE-10](https://github.com/Benedicht/BestHTTP-Issues/issues/10)] Fixed a case where HTTPRequest's async isn't returned when called with an already canceled cancellation token
- [<span style="color:red">Bugfix</span>] Fixed a name collusion that produced an *[Error] Failed to call static function Reset because an object was provided* error in the editor.
- [<span style="color:red">Bugfix</span>] Fixes for Configurable Enter Play Mode.
- [<span style="color:red">Bugfix</span>] Moved SetSocketOption into the nearest try-catch block. It should workaround a rare Unity error where setting KeepAlive on the socket level throws an exception under UWP.
- [<span style="color:red">Bugfix</span>] The plugin no longer going to reuse memory assigned to HTTPRequest's RawData.
- [<span style="color:red">Bugfix</span>] HTTPCacheService's DeleteEntity now going to be trigger a save library event
- [<span style="color:red">Bugfix</span>] Switched to Write locks in HTTPCacheService's SaveLibrary to prevent parallel executions

**HTTP/2**

- [<span style="color:green">New Feature</span>] [[ISSUE-15](https://github.com/Benedicht/BestHTTP-Issues/issues/15)] Trailing headers support.
- [<span style="color:blue">Improvement</span>] Log unexpected exceptions only when the plugin isn't shutting down
- [<span style="color:blue">Improvement</span>] Log unhandled frames
- [<span style="color:blue">Improvement</span>] To fix long-polling request issues over HTTP/2, the plugin no longer closes HTTP/2 streames after 30 seconds when it stays in HalfClosedLocal state.

**SignalR Core**

- [<span style="color:green">New Feature</span>] [[ISSUE-5](https://github.com/Benedicht/BestHTTP-Issues/issues/5)] Implemented connection timeout. However, all IAuthenticationProvider now requires to implement the Cancel method too.
- [<span style="color:green">New Feature</span>] `GetUpStreamController` and `GetUpAndDownStreamController` now can send non-streaming parameters too.
- [<span style="color:green">New Feature</span>] HubOptions now has a new `PingTimeoutInterval`.
- [<span style="color:blue">Improvement</span>] Improved the default authenticator to also set the access_token parameter under WebGL
- [<span style="color:blue">Improvement</span>] Authentication providers now will receive a real websocket url (one that starts with ws:// or wss://) in their PrepareUri to be able to differentiate between HTTP and WebSocket
- [<span style="color:red">Bugfix</span>] Send/Invoke tasks don't complete if not connected
- [<span style="color:red">Bugfix</span>] Fixed timeout by making it dependent on received messages instead of sent messages.
- [<span style="color:red">Bugfix</span>] Pings are not sent by the server for the long-polling transport, so every successful response generates one.

**Websocket**

- [<span style="color:red">Bugfix</span>] [[ISSUE-14](https://github.com/Benedicht/BestHTTP-Issues/issues/14)] Disposing newFrameSignal wasn't thread safe
- [<span style="color:red">Bugfix</span>] InternalRequest is now aborted if Close called while connecting.
- [<span style="color:blue">Improvement</span>] Fixed OnError double checking and reduced it to an else one. 

**Server-Sent Events**

- [<span style="color:green">New Feature</span>] Added new OnComment event that will be called for comments sent by the server.
- [<span style="color:blue">Improvement</span>] Reduced EnqueueProtocolEvent calls when one chunk of data result in more than one events.
- [<span style="color:red">Bugfix</span>] It now registers as a protocol and receives cancel requests on shutdown.

## 2.0.6 (2020-04-15)

**General**

- [<span style="color:red">Bugfix</span>] [[ISSUE-3](https://github.com/Benedicht/BestHTTP-Issues/issues/3)] HTTP/1 - Aborts & timeouts are handled only when there's activity on the handler's thread
- [<span style="color:red">Bugfix</span>] Fixed a memory leak of the TCP stream

**SignalR Core**

- [<span style="color:red">Bugfix</span>] [[ISSUE-4](https://github.com/Benedicht/BestHTTP-Issues/issues/4)] Fixed race condition in HubConnection's CloseAsync
- [<span style="color:red">Bugfix</span>] When the application is quitting HubConnection is going to report a normal closure now

**SocketIO**

- [<span style="color:red">Bugfix</span>] Fixed a bug where reconnecting while waiting for a pong message prevented all further ping messages 

**HTTP/2**

- [<span style="color:red">Bugfix</span>] Fixed a NullReferenceException when the server sends no initial settings.
- [<span style="color:red">Bugfix</span>] Fixed a case where streaming was on and the HTTP2Stream closed itself because of a timeout
- [<span style="color:red">Bugfix</span>] Moved clean-up code into one place and AutoResetEvent's close is called when both threads are closed insted of the HTTP2Handler's dispose as it might be called sooner while the AutoResetEvent still in use
- [<span style="color:red">Bugfix</span>] Request's state is now properly set to TimedOut instead of just Aborted to mach behavior of the HTTP/1 implementation

## 2.0.5 (2020-03-18)

**General**

- [<span style="color:red">Bugfix</span>] Fixed an out of bounds exception in the StreamList (used by FileConnection) class
- [<span style="color:blue">Improvement</span>] StreamList now Disposes wrapped streams on the go

**SignalR Core**

- [<span style="color:red">Bugfix</span>] Implemented a workaround for UriBuilder behavior on Query building
- [<span style="color:red">Bugfix</span>] [MessagePack Protocol] Fixed a bug in ReadArguments target is unknown
- [<span style="color:red">Bugfix</span>] [MessagePack Protocol] BufferPoolMemoryStream now can expand when the initial buffer isn't enough
- [<span style="color:red">Bugfix</span>] [MessagePack Protocol] Fixed ReadVarInt as it returned a wrong value 
- [<span style="color:blue">Improvement</span>] [MessagePack Protocol] Type information no longer serialized
- [<span style="color:blue">Improvement</span>] [MessagePack Protocol] Implemented a new MessagePackExtensionTypeHandler to follow the msgpack spec on sending DateTime

**Websocket**

- [<span style="color:red">Bugfix</span>] newFrameSignal going to be disposed when all threads are finished

**HTTP/2**

- [<span style="color:red">Bugfix</span>] Fixed an issue in the frame view that caused issues when received compressed data.

**Examples**

- [<span style="color:green">New Feature</span>] New MultipartFormDataStream implementation to send streams as multiform/form-data encoded.

## 2.0.4 (2020-02-11)

**General**

- [<span style="color:green">New Feature</span>] Possible to override read buffer size through the ReadBufferSizeOverride property
- [<span style="color:red">Bugfix</span>] Long running streaming requests' state set to Timeout instead of Abort when aborted
- [<span style="color:red">Bugfix</span>] Fixed a StackOverflowException when read buffer was larger than StreamFragmentSize
- [<span style="color:red">Bugfix</span>] When ConfigureAwait set to false, HTTPResponse's Dispose may called before acccessing Data
- [<span style="color:red">Bugfix</span>] Fixed case to avoid overwriting already set cookie name and value
- [<span style="color:red">Bugfix</span>] Fixed a memory leak where HostConnection's CloseConnectionAfterInactivity is added back to the Timer
- [<span style="color:red">Bugfix</span>] Fixed compiler warning when BESTHTTP_DISABLE_HTTP2 is in use
- [<span style="color:red">Bugfix</span>] Don't process cached alt-svc header
- [<span style="color:red">Bugfix</span>] HTTPResponse's RawData no longer pooled
- [<span style="color:blue">Improvement</span>] Run IsCachedEntityExpiresInTheFuture check before anything else to do not open a TCP channel to the server
- [<span style="color:blue">Improvement</span>] Added "samesite" cookie parsing
- [<span style="color:blue">Improvement</span>] Log out connector Connect exceptions when log level set to All
- [<span style="color:blue">Improvement</span>] Refresh data on disk when the stored and downloaded data length differs
- [<span style="color:blue">Improvement</span>] Call TryToStore on a status code of 304 too
- [<span style="color:blue">Improvement</span>] Small improvement to allocate less memory per frame in the Timer.cs
- [<span style="color:blue">Improvement</span>] Cache-Control Stale-On-Error implementation
- [<span style="color:blue">Improvement</span>] It can handle multiple Cache-Control headers now

**HTTP/2**

- [<span style="color:blue">Improvement</span>] Retry added for requests whose started already when the connection is closed
- [<span style="color:red">Bugfix</span>] Some requests stuck when their processing started but the connections is closed
- [<span style="color:red">Bugfix</span>] Stream id was a static field, instead of a per-connection one
- [<span style="color:red">Bugfix</span>] Fixed a case where the reading thread didn't close
- [<span style="color:red">Bugfix</span>] Send lower-case header names
- [<span style="color:red">Bugfix</span>] Keep around a canceled request's stream to receive and process the server-sent headers. Otherwise the HPACK encoder remains in a faulty state
- [<span style="color:red">Bugfix</span>] Aborting a request while processing its header/data frames before the HTTP2Stream's Process set the request's State to Finished, while its result remained null
- [<span style="color:red">Bugfix</span>] Added logging for a possible content-length parse error case

**SignalR Core**

- [<span style="color:green">New Feature</span>] New `ConnectAsync`, `CloseAsync`, `InvokeAsync` and `SendAsync` functions.
- [<span style="color:green">New Feature</span>] New sample to demonstrate the usage of the new *Async functions
- [<span style="color:red">Bugfix</span>] In some cases the HubConnection remained open while received an error using the Long-Polling transport.
- [<span style="color:blue">Improvement</span>] New NegotiationResponse property added to the NegotiationResult class. It's a HTTPResponse object reference to the last /negotiate request.

**SocketIO**

- [<span style="color:blue">Improvement</span>] New "reconnect_before_offline_packets" event.
- [<span style="color:red">Bugfix</span>] Do not delete offline packets on each reconnect attempt

**Server-Sent Events**

- [<span style="color:green">New Feature</span>] New constructor parameter to override default read buffer size on non-WebGL builds when the server sends data non-chunked

## 2.0.3 (2019-12-06)

**General**

- [<span style="color:blue">Improvement</span>] Reworked response reading to do not depend on StreamFragmentSize for download progress reporting
- [<span style="color:blue">Improvement</span>] HTTPResponse.MinBufferSize renamed to MinReadBufferSize
- [<span style="color:blue">Improvement</span>] VersionMajor and VersionMinor now set for HTTPResponse when it was created from a HTTP/2 connection too
- [<span style="color:blue">Improvement</span>] Merged recent LitJson changes

**HTTP/2**

- [<span style="color:green">New Feature</span>] Implemented upload streaming and upload progress reporting

**SignalR Core**

- [<span style="color:green">New Feature</span>] Implemented MessagePack protocol using the *Json & MessagePack Serialization* [Unity Asset Store package](https://assetstore.unity.com/packages/tools/network/json-messagepack-serialization-59918)
- [<span style="color:blue">Improvement</span>] Under WebGL built with Unity 2019.2 Uri's IsAbsoluteUri returns the wrong value
- [<span style="color:red">Bugfix</span>] Redirect uri's query parameters are removed while parsing and/or adding the negotiateVersion query param
- [<span style="color:red">Bugfix</span>] LongPolling now handles the handshake response

**Websocket**

- [<span style="color:red">Bugfix</span>] OnClose event called more than once

## 2.0.2 (2019-11-22)

**General**

- [<span style="color:red">Bugfix</span>] HostConnection's AddProtocol didn't set the new known protocol causing request processing delays in some cases
- [<span style="color:red">Bugfix</span>] Parts of the SignalR samples are back
- [<span style="color:red">Bugfix</span>] Fixed compile errors when specific plugin defines are added
- [<span style="color:blue">Improvement</span>] Improved CookieJar's domain matching


**HTTP/2**

- [<span style="color:green">New Feature</span>] Added PingFrequency option to HTTPManager.HTTP2Settings
- [<span style="color:red">Bugfix</span>] Pong messages didn't send back the server's payload
- [<span style="color:red">Bugfix</span>] HTTP2Handler used HTTPManager.MaxConnectionIdleTime instead of HTTPManager.HTTP2Settings.MaxIdleTime

**SignalR Core**

- [<span style="color:green">New Feature</span>] LongPolling transport added
- [<span style="color:green">New Feature</span>] Automatic transport downgrade

## 2.0.1 (2019-11-17)

**HTTP/2**

- [<span style="color:red">Bugfix</span>] "host" header must not sent in a HTTP/2 request

**General**

- [<span style="color:red">Bugfix</span>] Request's Response can be null when the ConnectionHelper tries to determine whether the connection can be kept open

**Socket.IO**

- [<span style="color:red">Bugfix</span>] Fixed an error that thrown when the packet's payload contained unicode characters.
- [<span style="color:red">Bugfix</span>] Fixed error packet deserialization when the code field isn't an integer

**SignalR Core**

- [<span style="color:red">Bugfix</span>] Fixed compile errors when BESTHTTP_DISABLE_WEBSOCKET present
- [<span style="color:green">New Feature</span>] Added support for allowReconnect in the close message (ASP.Net 3.1 feature)

 
## 2.0.0 (2019-10-31)

{% include warning.html content="**This is a major release breaking backward compatibility with older releases. See the [Upgrade Guide](/UpgradeGuide/) for more details!**" %}

**General**

- [<span style="color:green">New Feature</span>] Added [Application-Layer Protocol Negotiation](https://www.keycdn.com/support/alpn) support to the BouncyCastle lib
- [<span style="color:green">New Feature</span>] HTTP/2 Support added
- [<span style="color:green">New Feature</span>] New HTTP2Settings property added to the HTTPManager class
- [<span style="color:green">New Feature</span>] Initial implementation of [HTTP Alternate Services](https://tools.ietf.org/html/rfc7838)
- [<span style="color:green">New Feature</span>] Added support for Unity 2019.3's [(experimental) Enter Play Mode options](https://blogs.unity3d.com/2019/08/27/unity-2019-3-beta-is-now-available/)
- [<span style="color:green">New Feature</span>] Added [Assembly Definition file](https://docs.unity3d.com/Manual/ScriptCompilationAssemblyDefinitionFiles.html) to reduce recompile times
- [<span style="color:blue">Improvement</span>] Rewrote threading to avoid race conditions and reduce locking by using concurrent queues and lightweight `ReaderWriterLockSlim`s instead of lock blocks.
- [<span style="color:blue">Improvement</span>] New [online documentation](https://benedicht.github.io/BestHTTP-Documentation/)
- [<span style="color:red">Breaking change</span>] Removed Statistics API
- [<span style="color:red">Breaking change</span>] Changed some BouncyCastle related class' namespace to avoid collition with other plugins and SDKs
- [<span style="color:red">Breaking change</span>] Rewrote Abort mechanism
- [<span style="color:red">Breaking change</span>] Minumum Unity version is now 2017.3
- [<span style="color:red">Bugfix</span>] When the plugin is forced to use url-encoded form with binary data, it will base64 encode the data first

**HTTPRequest**

- [<span style="color:red">Breaking change</span>] New easier to use http streaming API through the `OnStreamingData` event
- [<span style="color:red">Breaking change</span>] Renamed `OnProgress` to `OnDownloadProgress`
- [<span style="color:red">Breaking change</span>] Removed `DisableRetry`, use `MaxRetries` instead
- [<span style="color:red">Breaking change</span>] Removed `Priority` property
- [<span style="color:red">Breaking change</span>] Removed `TryToMinimizeTCPLatency` property
- [<span style="color:red">Breaking change</span>] Removed `GetStreamedFragments` function, use the new `OnStreamingData` event
- [<span style="color:red">Breaking change</span>] Removed HTTPFormUsage.RawJSon support

**Server-Sent Events**

- [<span style="color:blue">Improvement</span>] Rewrote implementation to support Server-Sent Events over HTTP/2

**SocketIO**

- [<span style="color:blue">Improvement</span>] Improved compatibility with newer WebAssembly runtime

**Websocket**

- [<span style="color:red">Breaking change</span>] Removed OnErrorDesc event
- [<span style="color:red">Breaking change</span>] OnError event now has a string parameter instead of an Exception

**SignalR Core**

- [<span style="color:green">New Feature</span>] Added automatic reconnection support through the new IRetryPolicy interface
- [<span style="color:blue">Improvement</span>] Improved ASP.Net Core 3 compatibility
- [<span style="color:red">Breaking change</span>] Changed up and down streaming API