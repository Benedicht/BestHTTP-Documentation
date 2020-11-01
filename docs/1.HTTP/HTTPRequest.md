Here are the complete list of usable constructors, functions and properties.

## Constructors

- `HTTPRequest(Uri uri)`: Creates a new HTTPRequest object to access the given resource with a GET request. This constructor can be used with [Async-Await](AdvancedTopics/Async-await.md).

```language-csharp
var request = new HTTPRequest(new Uri("https://example.org"));
```

- `HTTPRequest(Uri uri, OnRequestFinishedDelegate callback)`: Creates a new HTTPRequest object to access the given resource with a GET request. When finished, the given callback will be called.

```language-csharp
var request = new HTTPRequest(new Uri("https://example.org"), callback: OnRequestFinished);

void OnRequestFinished(HTTPRequest req, HTTPResponse resp)
{
}
```

- `HTTPRequest(Uri uri, bool isKeepAlive, OnRequestFinishedDelegate callback)`: Same as the previous, but with an additional hint that we don't want to reuse the TCP connection. (Keep alive setting is ignored when the client can negotiate a [HTTP/2 connection](../7.GlobalTopics/HTTP2.md).)

```language-csharp
var request = new HTTPRequest(new Uri("https://example.org"), isKeepAlive: false, callback: OnRequestFinished);

void OnRequestFinished(HTTPRequest req, HTTPResponse resp)
{
}
```

!!! Notice
	isKeepAlive is just a hint. For example if the plugin can negotiate a HTTP/2 connection, it's still going to keep the connection alive.

- `HTTPRequest(Uri uri, bool isKeepAlive, bool disableCache, OnRequestFinishedDelegate callback)`: Same as the previous, but the plugin will not try to load the content from the cache and saving to the cache is ignored too.

```language-csharp
var request = new HTTPRequest(new Uri("https://example.org"), isKeepAlive: true, disableCache: false, callback: OnRequestFinished);

void OnRequestFinished(HTTPRequest req, HTTPResponse resp)
{
}
```

- `HTTPRequest(Uri uri, HTTPMethods methodType)`: Creates a new HTTPRequest object to access the given resource using the given method(HEAD, GET, POST, PUT, DELETE, PATCH, MERGE, OPTIONS). This constructor can be used with [Async-Await](AdvancedTopics/Async-await.md).

```language-csharp
var request = new HTTPRequest(new Uri("https://example.org"), methodType: HTTPMethods.Post);
```

- `HTTPRequest(Uri uri, HTTPMethods methodType, OnRequestFinishedDelegate callback)`: Creates a new HTTPRequest object to access the given resource using the given method(HEAD, GET, POST, PUT, DELETE, PATCH, MERGE, OPTIONS). When finished, the given callback will be called.

```language-csharp
var request = new HTTPRequest(new Uri("https://example.org"), methodType: HTTPMethods.Post, callback: OnRequestFinished);

void OnRequestFinished(HTTPRequest req, HTTPResponse resp)
{
}
```

- `HTTPRequest(Uri uri, HTTPMethods methodType, bool isKeepAlive, OnRequestFinishedDelegate callback)`: Same as the previous, but with an additional hint that we don't want to reuse the TCP connection. (Keep alive setting is ignored when the client can negotiate a [HTTP/2 connection](../7.GlobalTopics/HTTP2.md).)

```language-csharp
var request = new HTTPRequest(new Uri("https://example.org"), methodType: HTTPMethods.Post, isKeepAlive: false, callback: OnRequestFinished);

void OnRequestFinished(HTTPRequest req, HTTPResponse resp)
{
}
```

- `HTTPRequest(Uri uri, HTTPMethods methodType, bool isKeepAlive, bool disableCache, OnRequestFinishedDelegate callback)`: Same as the previous, but the plugin will not try to load the content from the cache and saving to the cache is ignored too.

```language-csharp
var request = new HTTPRequest(new Uri("https://example.org"), methodType: HTTPMethods.Post, isKeepAlive: false, disableCache: true, callback: OnRequestFinished);

void OnRequestFinished(HTTPRequest req, HTTPResponse resp)
{
}
```

## Properties

- `Uri Uri`: The original request the HTTPRequest is created with.
- `Uri RedirectUri`: The Uri that the request redirected to.
- `Uri CurrentUri`: Returns with `RedirectUri` if `IsRedirected` is true, returns with the original `Uri` otherwise.
- `bool IsRedirected`: Indicates that the request is redirected.
- `HTTPMethods MethodType`: The method that how we want to process our request the server.
- `byte[] RawData`: The raw data to send in a POST request. If it set all other fields that added to this request will be ignored.
- `Stream UploadStream`: The stream that the plugin will use to get the data to send out the server. When this property is set, no forms or the RawData property will be used.
- `bool DisposeUploadStream`: When set to true(its default value) the plugin will call the UploadStream's Dispose() function when finished uploading the data from it. Default value is true.
- `bool UseUploadStreamLength`: If it's true, the plugin will use the Stream's Length property. Otherwise the plugin will send the data chunked. Default value is true.
- `bool IsKeepAlive`: Indicates that the connection should be open after the response received. If its true, then the internal TCP connections will be reused if it's possible. Default value is true. The default value can be changed in the [`HTTPManager`](../7.GlobalTopics/GlobalSettings.md) class. If you make rare request to the server it's should be changed to false.
- `bool DisableCache`: With this property caching can be enabled/disabled on a per-request basis.
- `bool CacheOnly`: It can be used with streaming. When set to true, no `OnStreamingData` event is called, the streamed content will be saved straight to the cache if all requirements are met(caching is enabled and there's a caching headers).
- `int StreamFragmentSize`: Maximum size of a data chunk that we want to receive when streaming is set. Its default value is 1 MB.
- `bool StreamChunksImmediately`: When set to true, `StreamFragmentSize` will be ignored and downloaded chunks will be sent immediately.
- `int ReadBufferSizeOverride`: This property can be used to force the HTTPRequest to use an exact sized read buffer.
- `int MaxFragmentQueueLength`: Maximum unprocessed fragments allowed to queue up.
- `DateTime ProcessingStarted`: When the processing of the request started.
- `bool IsTimedOut`: Returns true if the time passed the Timeout setting since processing started.
- `int Retries`: Number of times that the plugin retried the request.
- `int MaxRetries`: Maximum number of tries allowed. To disable it set to 0. Its default value is 1 for GET requests, otherwise 0.
- `bool IsCancellationRequested`: True if `Abort()` is called on this request.	
- `HTTPResponse Response`: The response to the query. It can be null when the request times out, aborted, there's connection issues, etc.
- `HTTPResponse ProxyResponse`: Response from the Proxy server. It's null with transparent proxies.
- `Exception Exception`: It there is an exception while processing the request or response the Response property will be null, and the Exception will be stored in this property. For more information see the [Error Handling](AdvancedTopics/ErrorHandling.md) topic.
- `object Tag`: Any object can be passed with the request with this property, the plugin doesn't overwrites it. (eq. it can be identified, etc.)
- `Credentials Credentials`: The UserName, Password pair that the plugin will use to authenticate to the remote server with HTTP Authentication. The plugin supports Basic and Digest HTTP authentication.
- `bool HasProxy`: True, if there is a Proxy object set for the `Proxy` property.
- `Proxy Proxy`: A web [proxy](../7.GlobalTopics/Proxy.md)'s properties where the request must pass through.
- `int MaxRedirects`: How many redirection supported for this request. The default is int.MaxValue. 0 or a negative value means no redirection supported.
- `bool UseAlternateSSL`: Use Bouncy Castle's code to handle the secure protocol instead of Mono's. Its default value is true. Read more about [HTTPS](../7.GlobalTopics/HTTPS.md).

!!! Notice
	If there's an active connection to the server the plugin doesn't check what SSL/TLS handler is used for that connection, 

- `bool IsCookiesEnabled`: If true cookies will be added to the headers (if any), and parsed from the response. If false, all cookie operations will be ignored. It's default value is [`HTTPManager`](../7.GlobalTopics/GlobalSettings.md#iscookiesenabled)'s `IsCookiesEnabled`.
- `List<Cookie> Cookies`: Cookies that are added to this list will be sent to the server alongside withe the server sent ones. If cookies are disabled only these cookies will be sent.
- `HTTPFormUsage FormUsage`: What form should used. Its default value is Automatic.
- `HTTPRequestStates State`: Current state of this request.
- `int RedirectCount`: How many times the request redirected.
- `Func<HTTPRequest, System.Security.Cryptography.X509Certificates.X509Certificate, System.Security.Cryptography.X509Certificates.X509Chain, bool> CustomCertificationValidator`: Custom validator for an SslStream. This event will receive the original HTTPRequest, an X509Certificate and an X509Chain objects. It must return true if the certificate valid, false otherwise. It's not available when `UseAlternateSSL` is true and on some platforms!
- `TimeSpan ConnectTimeout`: Maximum time we wait to establish the connection to the target server. If set to TimeSpan.Zero or lower, no connect timeout logic is executed. Default value is 20 seconds.
- `TimeSpan Timeout`: Maximum time we want to wait to the request to finish after the connection is established. Default value is 60 seconds. It's disabled for streaming requests! See `EnableTimoutForStreaming`.
- `bool EnableTimoutForStreaming`: Set to true to enable Timeouts on streaming request. Default value is false.
- `bool EnableSafeReadOnUnknownContentLength`: Enables safe read method when the response's length of the content is unknown. Its default value is enabled (true).
- `SecureProtocol.Org.BouncyCastle.Crypto.Tls.ICertificateVerifyer CustomCertificateVerifyer`: The `ICertificateVerifyer` implementation that the plugin will use to verify the server certificates when the request's `UseAlternateSSL` property is set to true.
- `SecureProtocol.Org.BouncyCastle.Crypto.Tls.IClientCredentialsProvider CustomClientCredentialsProvider`: The `IClientCredentialsProvider` implementation that the plugin will use to send client certificates when the request's `UseAlternateSSL` property is set to true.
- `List<string> CustomTLSServerNameList`: With this property custom Server Name Indication entries can be sent to the server while negotiating TLS. All added entries must conform to the rules defined in [RFC 3546](https://tools.ietf.org/html/rfc3546#section-3.1), the plugin will not check the entries' validity! *This list will be sent to every server that the plugin must connect to while it tries to finish the request. So for example if redirected to an another server, that new server will receive this list too!*
- `LoggingContext Context`: [Logging context](../7.GlobalTopics/Logging.md#LoggingContext) of the request.
- `TimingCollector Timing`: [Timing information](AdvancedTopics/Timing.md).
- `WithCredentials`: Its value will be set to the [XmlHTTPRequest](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest)'s [withCredentials](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/withCredentials) field. Its default value is [`HTTPManager.IsCookiesEnabled`](../7.GlobalTopics/GlobalSettings.md#iscookiesenabled)'s value. It's WebGL only.

## Events

- `Action<HTTPRequest, HTTPResponse> OnHeadersReceived`: This event is called when the plugin received and parsed all headers.
- `OnBeforeRedirectionDelegate OnBeforeRedirection`: It's called before the plugin will do a new request to the new uri. The return value of this function will control the redirection: if it's false the redirection is aborted. This function is called on a thread other than the main Unity thread!
- `OnBeforeHeaderSendDelegate OnBeforeHeaderSend`: This event will be fired before the plugin will write headers to the wire. New headers can be added in this callback. This event is called on a non-Unity thread!
- `OnRequestFinishedDelegate Callback`: The callback function that will be called when a request is fully processed or when any downloaded fragment is available if UseStreaming is true. Can be null for fire-and-forget requests.
- `OnDownloadProgressDelegate OnDownloadProgress`: Called when new data downloaded from the server. The first parameter is the original HTTTPRequest object itself, the second parameter is the downloaded bytes while the third parameter is the content length. 

!!! Notice 
	There are download modes where we can't figure out the exact length of the final content. In these cases we just guarantee that the third parameter will be at least the size of the second one.

- `OnStreamingDataDelegate OnStreamingData`: Called for every fragment of data downloaded from the server. Return true if dataFrament is processed and the plugin can recycle the `byte[]`.
- `OnUploadProgressDelegate OnUploadProgress`: Called after every chunk of data sent out to the wire.

## Form Functions

HTTP defines two types of form encoding: [URL Encoded and Multipart Forms](https://dev.to/sidthesloth92/understanding-html-form-encoding-url-encoded-and-multipart-forms-3lpa). The plugin supports both of them and selects the most performing one automatically. 
Sometime servers supports one specific encoding only and expects data in that one encoding. In this case the `FormUsage` property can be used to force the plugin to use that encoding method for the request:

```language-csharp
var request = new HTTPRequest(new Uri("https://httpbin.org/post"), HTTPMethods.Post, OnRequestFinished);

request.AddField("field name", "field value");
request.FormUsage = BestHTTP.Forms.HTTPFormUsage.Multipart;

request.Send();
```

!!! Notice
	These functions can be used to send *form*s, sending JSon or any other data the `RawData` or `UploadStream` properties can be used!

- `void AddField(string fieldName, string value)`: Add a field with a given string value.
- `void AddField(string fieldName, string value, System.Text.Encoding e)`: Add a field with a given string value. The plugin going to send encoding information too.
- `void AddBinaryData(string fieldName, byte[] content)`: Add a field with binary content to the form.
- `void AddBinaryData(string fieldName, byte[] content, string fileName)`:Add a field with binary content to the form.
- `void AddBinaryData(string fieldName, byte[] content, string fileName, string mimeType)`: Add a field with binary content to the form.
- `void SetForm(HTTPFormBase form)`: Manually set a HTTP Form.
- `List<HTTPFieldData> GetFormFields()`: Returns with the added form-fields or null if no one added.
- `void ClearForm()`: Clears all data from the form.

## Header Functions

Long headers can be sent as one or more headers (for example the server might send multiple `set-cookie` headers), hence the plugin stores them in a list and `GetHeaderValues` returns with it. To help work with them easier, `GetFirstHeaderValue` returns with the first value from the list. This can be used when we know that the server going to send only one header.

- `void AddHeader(string name, string value)`: Adds a header and value pair to the Headers. Use it to add custom headers to the request.
- `void SetHeader(string name, string value)`: Removes any previously added values, and sets the given one.
- `bool RemoveHeader(string name)`: Removes the specified header. Returns true, if the header found and succesfully removed.
- `bool HasHeader(string name)`: Returns true if the given head name is already in the Headers.
- `string GetFirstHeaderValue(string name)`: Returns the first header or null for the given header name.
- `List<string> GetHeaderValues(string name)`: Returns all header values for the given header or null.
- `void RemoveHeaders()`: Removes all headers.

## Range Header Functions

Range headers can be used to resume to an unfinished download, download only parts of a (large) content or download multiple parts in parallel.

- `void SetRangeHeader(long firstBytePos)`: Sets the Range header to download the content from the given byte position. See [RFC 2616](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35).
- `void SetRangeHeader(long firstBytePos, long lastBytePos)`: Sets the Range header to download the content from the given byte position to the given last position. See [RFC 2616](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35).

## Other Functions

- `HTTPRequest Send()`: Starts processing the request.
- `void Abort()`: Aborts an already established connection, so no further download or upload are done.
- `void Clear()`: Resets the request for a state where switching MethodType is possible.