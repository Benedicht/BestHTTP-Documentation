## 2.0.3 (2019.12.06)

**HTTP/2**

- [<span style="color:green">New Feature</span>] Implemented upload streaming and upload progress reporting

**General**

- [<span style="color:blue">Improvement</span>] Reworked response reading to do not depend on StreamFragmentSize for download progress reporting
- [<span style="color:blue">Improvement</span>] HTTPResponse.MinBufferSize renamed to MinReadBufferSize
- [<span style="color:blue">Improvement</span>] VersionMajor and VersionMinor now set for HTTPResponse when it was created from a HTTP/2 connection too
- [<span style="color:blue">Improvement</span>] Merged recent LitJson changes

**SignalR Core**

- [<span style="color:green">New Feature</span>] Implemented MessagePack protocol using the *Json & MessagePack Serialization* [Unity Asset Store package](https://assetstore.unity.com/packages/tools/network/json-messagepack-serialization-59918)
- [<span style="color:blue">Improvement</span>] Under WebGL built with Unity 2019.2 Uri's IsAbsoluteUri returns the wrong value
- [<span style="color:red">Bugfix</span>] Redirect uri's query parameters are removed while parsing and/or adding the negotiateVersion query param
- [<span style="color:red">Bugfix</span>] LongPolling now handles the handshake response

**Websocket**

- [<span style="color:red">Bugfix</span>] OnClose event called more than once

## 2.0.2 (2019.11.22)

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

## 2.0.1 (2019.11.17)

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

 
## 2.0.0 (2019.10.31)

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