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
- [<span style="color:blue">Improvement</span>] [WebGL] Add Set-Cookie header ibky when its value isn't empty
- [<span style="color:blue">Improvement</span>] [WebGL] Use the default IO service under WebGL too, but explicitly disable the caching service and cookie saving
- [<span style="color:blue">Improvement</span>] Removed non-used ConcurrentStack file
- [<span style="color:blue">Improvement</span>] Don't keep an HTTP1 connection in the connection pool if the last processed request/response returned max=0 in a Keep-Alive header

** SignalR Core**

- [<span style="color:red">Bugfix</span>] [Long-Polling transport] Removed fake ping message as it's triggered a client-sent one, that triggered a new fake one, etc.
- [<span style="color:blue">Improvement</span>] [MessagePackProtocol] Added support for parameterless callbacks

** Websocket**

- [<span style="color:red">Bugfix</span>] [Long-Polling transport] Use WebSocket's `MaxFragmentSize` in WebSocketResponse

** Socket.IO 3**

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

- [<span style="color:green">New Feature</span>] New [Websocket Over HTTP/2 implementation](/2.WebSocket/#implementations)

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

- [<span style="color:green">New Feature</span>] A [new Socket.IO implementation](3.1Socket.IO3/index.md) for Socket.IO 3 with [strongly typed callbacks](3.1Socket.IO3/index.md#subscribing-to-events)!
- [<span style="color:green">New Feature</span>] New parser interface to be able to implement parsers other than json
- [<span style="color:green">New Feature</span>] New [MsgPackParser](3.1Socket.IO3/index.md#parsers)
- [<span style="color:blue">Improvement</span>] [Improved documentation](3.1Socket.IO3/index.md)

**SignalR Core**

- [<span style="color:red">Bugfix</span>] [Long-Polling Transport] stream got disposed while the transport tried to reuse it
- [<span style="color:blue">Improvement</span>] Introduced MessagePackProtocolSerializationOptions to be able to change how enums are serialized

**EventSource**

- [<span style="color:red">Bugfix</span>] [WebGL] Call Close on the browser's EventSource object to prevent its autmatic reconnection

**HTTP**

- [<span style="color:blue">Improvement</span>] [WebGL] UploadStream is now going to be uploaded too.

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

- [<span style="color:green">New Feature</span>] New [`Exceptions`](7.GlobalTopics/Proxy.md#add-exceptions) property for proxies to be able to skip proxy for specified hosts
- [<span style="color:red">Bugfix</span>] LitJson dictionary (object) instantiation fix
- [<span style="color:red">Bugfix</span>] HeartbeatManager wasn't cleared on application quit

**SocketIO**

- [<span style="color:green">New Feature</span>] Support for [Socket.IO 3](https://socket.io/blog/socket-io-3-release/)
- [<span style="color:green">New Feature</span>] New [ServerVersion option](3.Socket.IO/8.Options.md) that can be set if the server's Socket.IO version is known
- [<span style="color:green">New Feature</span>] New [Auth function](3.Socket.IO/8.Options.md) to send payload while connecting to a namespace (only with Socket.IO 3)
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

- [<span style="color:blue">Improvement</span>] Bouncy Castle optimizations: depending on the negotiated ciphers download speed can increase and memory hungry parts are also rewritten to use the plugin's [BufferPool](7.GlobalTopics/BufferPool.md) to decrease GC usage. As parts of the optimizations now the plugin requires the "Allow 'unsafe' Code" to be set
- [<span style="color:blue">Improvement</span>] Added the use of [Encrypt-then-MAC (RFC 7366)](https://tools.ietf.org/html/rfc7366) extension
- [<span style="color:blue">Improvement</span>] Added [ChaCha20-Poly1305 (RFC 7905](https://tools.ietf.org/html/rfc7905) ciphers to the client offered cipher suites to negotiate with the server
- [<span style="color:blue">Improvement</span>] Moved read buffer to the lowest level to reduce context switching when TLS is used, halving reads per TLS message
- [<span style="color:blue">Improvement</span>] Removed an optional error throwing to follow browser behavior

**General**

- [<span style="color:green">New Feature</span>] New [Timing API](1.HTTP/AdvancedTopics/Timing.md) to measure when request processing spent most of its time
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
- [<span style="color:blue">Improvement</span>] New [`AsyncHTTPException`](1.HTTP/AdvancedTopics/Async-await.md#handling-errors) added to be able to access the Status Code of the server's response.
- [<span style="color:blue">Improvement</span>] The HTTPUpdateDelegator going to be hidden in the inspector
- [<span style="color:blue">Improvement</span>] [HTTPManager's IsQuitting](7.GlobalTopics/GlobalSettings.md) is now public
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

- [<span style="color:green">New Feature</span>] New MultipartFormDataStream implementation to send streams as multipart/form-data encoded.

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

!!! Warning
**This is a major release breaking backward compatibility with older releases. See the [Upgrade Guide](/UpgradeGuide/) for more details!**

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