---
title: Connection Pool
sidebar: best_http2_main_sidebar
---

{% include note.html content="This topic applies to connections for HTTP/1.1 requests only. HTTP/2 has proper messaging to communicate state changes between the client and server." %}

Building up a TCP connection and negotiating TLS for HTTPS are slow that we can avoid if we reuse the connections for future requests. The plugin informs the server that it want to keep the connection alive for future use by sending a "*Connection: Keep-Alive*" header. 
While the server could inform the client [by sending back a *Keep-Alive* header](https://tools.ietf.org/html/draft-thomson-hybi-http-timeout-03) about how much time it’s going to wait for a new request before get bored and closing the connection, 
servers are rarely use and send this *Keep-Alive* header. So, both the server and clients are blind to each other's setting and there’s no other way other than the keep-alive header to let the other side know when the connection is going to be closed.


In a case where the server closes an idle connection after 5 seconds and the client goes with its default 20 seconds, the client going to try to (re)use the connection way behind 5 seconds, resulting in a failed request. 

One option to fix it to set either the server’s or the client’s setting to the same as the other. 
Another one is to disable connection reuse completely (set HTTPManager.KeepAliveDefaultValue to false). While this is the safest way, and in some cases can be beneficial (for example when you know that you going to send out requests sparingly, outside of the idle time), 
it’s better to try to keep the server and client setting in sync to reuse a TCP connection as much as possible.

So, it worked because with the new setting, both the client and server closed the connection about the same time. Setting the client to the same value still can result in failed connections however, because the server starts to count down when it finished writing the response to the wire, 
and the client starts to count down when it finished receiving it. With a slow network (== high network latency), this can be large enough to increase the chance that the client is trying to use a server-closed connection. 
If you want to use connection pooling but want a safer value, I would recommend to set the client’s setting one seconds lower than the server has.

To set the idle time for the client the `MaxConnectionIdleTime` property can be used:

```csharp
HTTPManager.MaxConnectionIdleTime = TimeSpan.FromSeconds(4);
```

Disable connection pooling:
```csharp
HTTPManager.KeepAliveDefaultValue = false;
```