# Proxy

There are two types of proxies the plugin supports: HTTP (`HTTPProxy`) and SOCKS (`SOCKSProxy`).

A proxy object can be set to a HTTPRequest’s Proxy property. This way the request will be go through the given proxy.

```language-csharp
// HTTP Proxy:
request.Proxy = new HTTPProxy(new Uri("http://localhost:3128"));

// SOCKS Proxy:
request.Proxy = new SOCKSProxy(new System.Uri("socks://localhost:3129"), /*credentials: */ null);
```

You can set a global proxy too, so you don’t have to set it to all request manually or to drive higher level protocols through it:

```language-csharp
// Global HTTP Proxy:
HTTPManager.Proxy = new HTTPProxy(new Uri("http://localhost:3128"));

// Global SOCKS Proxy:
HTTPManager.Proxy = new SOCKSProxy(new System.Uri("socks://localhost:3129"), /*credentials: */ null);
```

See the [Global Settings](Global Settings.md) chapter for more settings.
