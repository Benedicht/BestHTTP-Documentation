# HTTP/2

## How it works

BestHTTP implements HTTP/2 over TLS. Using the TLS negotiation and its ALPN extension the plugin let the server know that it's ready to upgrade to the HTTP/2 protocol. 
If the server has support for HTTP/2 and sends back the proper answer the plugin upgrades the connection and will communicate with the server using the HTTP/2 protocol. Using the TLS' ALPN extension upgrading to HTTP/2 is faster.

However, when multiple requests are made to the same server and the plugin don't know whether the server capable to upgrade to HTTP/2, it will create only one connection to test against http/2. If the server reports no HTTP/2/2 support, the plugin will open new connections depending on the value of `HTTPManager.MaxConnectionPerServer`. if the server supports HTTP/2, the plugin will use that connection only.
This mechanism prevents the plugin to open multiple connections that will be used only for one request. The plugin also stores what servers are supporting HTTP/2, so next time it can decide whether it should open multiple connections or not.

Using HTTP/2 is seemless and requires no prior knowledge whether any target servers has support for it or not. The plugin hides differencies HTTP1.1 and HTTP/2 from the user, but will take advantage of the new protocol every time it has a chance.

## Settings

As most of the global settings, HTTP/2 settings can be accessed through the `HTTPManager` class:
```language-csharp
using BestHTTP;

HTTPManager.HTTP2Settings.InitialStreamWindowSize = 5 * 1024 * 1024;
```

Current options are the following:

1. **MaxConcurrentStreams**: Maximum concurrent http2 stream on http2 connection will allow. Its default value is 128;
2. **InitialStreamWindowSize**: Initial window size of a http2 stream. Its default value is 10 MiB (10 * 1024 * 1024).
3. **InitialConnectionWindowSize**: Global window size of a http/2 connection. Its default value is the maximum possible value on 31 bits.
4. **MaxFrameSize**: Maximum size of a http2 frame. Its default value is 16384.
5. **MaxIdleTime**: With HTTP/2 only one connection will be open so we can can keep it open longer as we hope it will be resued more. Its default value is 120 seconds.