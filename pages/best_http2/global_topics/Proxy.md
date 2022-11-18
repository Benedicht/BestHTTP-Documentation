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

## Automatic Proxy Detection
(v2.8.0 or newer versions.)

{% include warning.html content="Automatic Proxy Detection is an experimental feature, its API might change in the future. Use it with caution!" %}

Automatic proxy detection is coordinated by the `ProxyDetector` class. It can be disabled by setting `HTTPManager.ProxyDetector` to `null`.
To set the proxy detector with default settings the following line can be added before sending out the first request:
```csharp
BestHTTP.HTTPManager.ProxyDetector = new BestHTTP.Proxies.Autodetect.ProxyDetector();
```

Proxy detection can work in two mode:
1. `ProxyDetectionMode.CacheFirstFound`: In this mode the detector will cache (in `HTTPManager.Proxy`) and reuse the first proxy it can find.
2. `ProxyDetectionMode.Continouos`: In Continouos mode the ProxyDetector will check for a proxy for every request.

By default the proxy detector will use `ProxyDetectionMode.CacheFirstFound`, but it can be changed through its constructor:
```csharp
BestHTTP.HTTPManager.ProxyDetector = new BestHTTP.Proxies.Autodetect.ProxyDetector(ProxyDetectionMode.Continouos);
```

Automatic proxy detection can be turned off by setting `BestHTTP.HTTPManager.ProxyDetector` to null:
```csharp
BestHTTP.HTTPManager.ProxyDetector = null;
```

or by calling `Detach()` on it:
```csharp
BestHTTP.HTTPManager.ProxyDetector.Detach();
```

Calling `Reattach()` or assigning a new `ProxyDetector` will restart proxy detection:
```csharp
BestHTTP.HTTPManager.ProxyDetector.Reattach();
```

### Limitations

Not all platforms are supported. Under WebGL proxies are detected/managed by the browser itself. `HTTPManager.Proxy`, `HTTPManager.ProxyDetector` and `HTTPRequest`'s `Proxy` not even compiled into the build to reduce build size. Proxy detection might or might not work under MacOS and iOS.

### Proxy detectors

These are the different implementations of the `IProxyDetector` interface that the `ProxyDetector` will use by default.

### ProgrammaticallyAddedProxyDetector

This detector has the highest priority (it's the first element of the list of detectors) and it just returns with `HTTPManager.Proxy`.

### EnvironmentProxyDetector

It will check for the `HTTP_PROXY`, `HTTPS_PROXY`, `ALL_PROXY` and `NO_PROXY` environment variables. It can be used for both SOCKS and HTTP proxies.

### FrameworkProxyDetector

This one uses the .net implementation of `System.Net.WebRequest.GetSystemWebProxy()`.  It can be used for both SOCKS and HTTP proxies.

### AndroidProxyDetector

A detector for Android systems using Java's [ProxySelector](https://docs.oracle.com/javase/8/docs/api/java/net/ProxySelector.html).

{% include warning.html content="This requires the built-in [Android JNI module](https://docs.unity3d.com/ScriptReference/UnityEngine.AndroidJNIModule.html), enable it through the [Package Manager window](https://docs.unity3d.com/Manual/upm-ui.html)!" %}