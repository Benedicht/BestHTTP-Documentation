#Proxy
A `HTTPProxy` object can be set to a HTTPRequest’s Proxy property. This way the request will be go through the given proxy.

```csharp
request.Proxy = new HTTPProxy(new Uri("http://localhost:3128"));
```

You can set a global proxy too, so you don’t have to set it to all request manually. See the [Global Settings](Global Settings.md) chapter.
