#Global Settings
With the following properties we can change some defaults that otherwise should be specified in the HTTPRequest’s constructor. So most of these properties are time saving shortcuts.
These changes will affect all request that created after their values changed.

Changing the defaults can be made through the static properties of the `HTTPManager` class:

- **MaxConnectionPerServer**: Number of connections allowed to a unique host. <http://example.org> and <https://example.org> are counted as two separate servers. The default value is **4**.
- **KeepAliveDefaultValue**: The default value of the HTTPRequest’s `IsKeepAlive` property. If `IsKeepAlive` is `false`, the tcp connections to the server will be set up before every request and closed right after it. It should be changed to false if consecutive requests are rare. Values given to the HTTPRequest’s constructor will override this value for this request. The default value is `true`.
- **IsCachingDisabled**: With this property we can globally disable or enable the caching service. Values given to the HTTPRequest’s constructor will override this value for this request. The default value is **true**.
- **MaxConnectionIdleTime**: Specifies the idle time BestHTTP should wait before it destroys the connection after it’s finished the last request. The default value is 2 minutes.
- **IsCookiesEnabled**: With this option all `Cookie` operation can be enabled or disabled. The default value is true.
- **CookieJarSize**: With this option the size of the `Cookie` store can be controlled. The default value is 10485760 (**10 MB**).
- **EnablePrivateBrowsing**: If this option is enabled no `Cookie` will be written to the disk. The default value is false. 
- **ConnectTimeout**: With this option you can set the HTTPRequests’ default `ConnectTimeout` value. The default value is 20 seconds.
- **RequestTimeout**: With this option you can set the HTTPRequests’ default Timeout value. The default value is 60 seconds.
- **RootCacheFolderProvider**: By default the plugin will save all cache and cookie data under the path returned by `Application.persistentDataPath`. You can assign a function to this delegate to return a custom root path to define a new path. **This delegate will be called on a non Unity thread!**
- **Proxy**: The global, default proxy for all HTTPRequests. The HTTPRequest's Proxy still can be changed per-request. Default value is `null`.
- **Logger**: An ILogger implementation to be able to control what information will be logged about the plugin’s internals, and how these will be logged.
- **DefaultCertificateVerifyer**: An `ICertificateVerifyer` implementation can be set to this property. All new requests created after this will use this verifier when a secure protocol is used and the request’s `UseAlternateSSL` is `true`. An `ICertificateVerifyer` implementation can be used to implement server certificate validation.
- **UseAlternateSSLDefaultValue**: The default value of HTTPRequest’s UseAlternateSSL can be changed through this property.

Sample codes:

```csharp
HTTPManager.MaxConnectionPerServer = 10;
HTTPManager.RequestTimeout = TimeSpan.FromSeconds(120);
```
