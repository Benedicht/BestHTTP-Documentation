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
- [<span style="color:red">Bugfix</span>] In some cases the HubConnection remained open while received an error using the Long-Polliong transport.
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
	**This is a major release breaking backward compatibility with older releases. See the [Upgrade Guide](https://besthttp-documentation.readthedocs.io/en/latest/Upgrade guide/) for more details!**

**General**

- [<span style="color:green">New Feature</span>] Added [Application-Layer Protocol Negotiation](https://www.keycdn.com/support/alpn) support to the BouncyCastle lib
- [<span style="color:green">New Feature</span>] HTTP/2 Support added
- [<span style="color:green">New Feature</span>] New HTTP2Settings property added to the HTTPManager class
- [<span style="color:green">New Feature</span>] Initial implementation of [HTTP Alternate Services](https://tools.ietf.org/html/rfc7838)
- [<span style="color:green">New Feature</span>] Added support for Unity 2019.3's [(experimental) Enter Play Mode options](https://blogs.unity3d.com/2019/08/27/unity-2019-3-beta-is-now-available/)
- [<span style="color:green">New Feature</span>] Added [Assembly Definition file](https://docs.unity3d.com/Manual/ScriptCompilationAssemblyDefinitionFiles.html) to reduce recompile times
- [<span style="color:blue">Improvement</span>] Rewrote threading to avoid race conditions and reduce locking by using concurrent queues and lightweight `ReaderWriterLockSlim`s instead of lock blocks.
- [<span style="color:blue">Improvement</span>] New [online documentation](https://besthttp-documentation.readthedocs.io/en/latest/)
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