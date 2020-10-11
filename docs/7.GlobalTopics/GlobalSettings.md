# Global Settings
With the following properties we can change some defaults that otherwise should be specified in the HTTPRequest's constructor. So most of these properties are time saving shortcuts, however, because higher level protocols use the `HTTPRequest` class too, these settings affect all protocols too.
These changes will affect all request that created after their values changed.

Changing the defaults can be made through the static properties of the `HTTPManager` class. Current settings are the following:

## MaxConnectionPerServer
Number of TCP connections allowed to a unique host. <http://example.org> and <https://example.org> are counted as two separate servers. Its default value is **6**.

```language-csharp
HTTPManager.MaxConnectionPerServer = 10;
```

!!! Notice
	[HTTP/2](HTTP2.md) uses one TCP connection, it has different setting for stream concurrency.

## KeepAliveDefaultValue
The default value of the HTTPRequest's `IsKeepAlive` property. If `IsKeepAlive` is `false`, the tcp connections to the server will be set up before every request and closed right after it. It should be changed to false if consecutive requests are rare. Values given to the HTTPRequest's constructor will override this value for this request. Its default value is `true`.

```language-csharp
HTTPManager.KeepAliveDefaultValue = false;
```

## IsCachingDisabled
With this property we can globally disable or enable the caching service. Values given to the HTTPRequest's constructor will override this value for this request. Its default value is **false**.

```language-csharp
HTTPManager.IsCachingDisabled = true;
```

## MaxConnectionIdleTime
Specifies the idle time BestHTTP should wait before it destroys the connection after it's finished the last request. Its default value is 20 seconds.

```language-csharp
HTTPManager.MaxConnectionIdleTime = TimeSpan.FromSeconds(60);
```

## IsCookiesEnabled
With this option all `Cookie` operation can be enabled or disabled. Its default value is true.

```language-csharp
HTTPManager.IsCookiesEnabled = false;
```

## CookieJarSize
With this option the size of the `Cookie` store can be controlled. Its default value is 10485760 (**10 MB**).

```language-csharp
HTTPManager.CookieJarSize = 1048576;
```

## EnablePrivateBrowsing
If this option is enabled no `Cookie` will be written to the disk. Its default value is false. 

```language-csharp
HTTPManager.EnablePrivateBrowsing = true;
```

## ConnectTimeout
With this option you can set the HTTPRequests' default `ConnectTimeout` value. Its default value is 20 seconds.

```language-csharp
HTTPManager.ConnectTimeout = TimeSpan.FromSeconds(60);
```

## RequestTimeout
With this option you can set the HTTPRequests' default Timeout value. Its default value is 60 seconds.

```language-csharp
HTTPManager.RequestTimeout = TimeSpan.FromSeconds(60);
```

## RootCacheFolderProvider
By default the plugin will save all cache and cookie data under the path returned by `Application.persistentDataPath`. You can assign a function to this delegate to return a custom root path to define a new path. **This delegate will be called on a non Unity thread!**

```language-csharp
HTTPManager.RootCacheFolderProvider = () => Application.temporaryCachePath;
```

## Proxy
The global, default proxy for all HTTPRequests. The HTTPRequest's Proxy still can be changed per-request. Default value is `null`. More information can be found about proxies in the [Proxy](Proxy.md) topic.

```language-csharp
HTTPManager.Proxy = new HTTPProxy(new Uri("http://localhost:8888"), null, true);
```

## Logger
An [ILogger implementation](Logging.md) to be able to control what information will be logged about the plugin's internals, and how these will be logged.

```language-csharp
HTTPManager.Logger = new ThreadedLogger();
```

## DefaultCertificateVerifyer
An `ICertificateVerifyer` implementation can be set to this property. All new requests created after this will use this verifier when a secure protocol is used and the request's `UseAlternateSSL` is `true`. An `ICertificateVerifyer` implementation can be used to implement server certificate validation.

```language-csharp
HTTPManager.DefaultCertificateVerifyer = new AlwaysValidVerifyer();
```

## UseAlternateSSLDefaultValue
The default value of HTTPRequest's UseAlternateSSL can be changed through this property. Its default value is `true`.

```language-csharp
HTTPManager.UseAlternateSSLDefaultValue = false;
```

## HTTP2Settings
Through this property, HTTP/2 related settings can be changed. See the [HTTP/2 topic for more information](HTTP2.md#settings).

```language-csharp
HTTPManager.HTTP2Settings.MaxConcurrentStreams = 256;
```

## IsQuitting
It's true if the application is quitting and the plugin is shutting down itself.

## UserAgent
User-agent string that will be sent with each requests. It's default value contains the version of the plugin (`"BestHTTP/2 v2.2.1"` for example).

```language-csharp
HTTPManager.UserAgent = string.Empty;
```