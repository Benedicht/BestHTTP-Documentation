---
title: Proxy
sidebar: best_http2_main_sidebar
---

## Proxies

There are two types of proxies the plugin supports: HTTP (`HTTPProxy`) and SOCKS (`SOCKSProxy`).

A proxy object can be set to a HTTPRequest’s Proxy property. This way the request will be go through the given proxy.

```csharp
// HTTP Proxy:
request.Proxy = new HTTPProxy(new Uri("http://localhost:3128"));

// SOCKS Proxy:
request.Proxy = new SOCKSProxy(new System.Uri("socks://localhost:3129"), /*credentials: */ null);
```

You can set a global proxy too, so you don’t have to set it to all request manually or to drive higher level protocols through it:

```csharp
// Global HTTP Proxy:
HTTPManager.Proxy = new HTTPProxy(new Uri("http://localhost:3128"));

// Global SOCKS Proxy:
HTTPManager.Proxy = new SOCKSProxy(new System.Uri("socks://localhost:3129"), /*credentials: */ null);
```

See the [Global Settings](GlobalSettings.md) chapter for more settings.

## HTTPProxy

The HTTPProxy implementation supports proxy authentication, explicit, transparent and non-transparent proxies. It supports sending the whole URL to the proxy because some non-transparent proxies expecting it.

## SOCKSProxy

Supports only the username/password authentication.

## Add Exceptions

To do not route one or more requests through a globally set proxy the proxy's `Exceptions` list can be used:

```csharp
HTTPManager.Proxy = new HTTPProxy(new Uri("http://localhost:8888"), null, true);

// Add exceptions
HTTPManager.Proxy.Exceptions = new List<string>();
HTTPManager.Proxy.Exceptions.Add("httpbin");

// This request not going through the proxy
var request = new HTTPRequest(new Uri("https://httpbin.org"));
request.Send();
```

Any request that's [CurrentUri](../protocols/http/HTTPRequest.md#properties).Host's beginning matches a string from the proxy's Exceptions will not going trhough the proxy.