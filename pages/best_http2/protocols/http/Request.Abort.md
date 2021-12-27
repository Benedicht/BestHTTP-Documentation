---
title: Request cancelling
sidebar: best_http2_main_sidebar
---

You can cancel an ongoing request by calling the `HTTPRequest` object’s `Abort()` function:

```csharp
request = new HTTPRequest(new Uri("http://yourserver.com/bigfile"), (req, resp) => { … });
request.Send();

// And after some time:
request.Abort();
```

The callback function will be called and the response object will be `null`.
