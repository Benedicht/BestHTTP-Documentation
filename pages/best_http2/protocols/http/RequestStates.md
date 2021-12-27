---
title: Request States
sidebar: best_http2_main_sidebar
---

All request has a State property that contains its internal state. The possible states are the following:

- **Initial**: Initial status of a request. No callback will be called with this status.
- **Processing**: Processing of the request started. In this state the client will send the request, and parse the response. No callback will be called with this status.
- **Finished**: The request finished without problem. Parsing the response done, the result can be used. The user defined callback will be called with a valid response object. The request’s `Exception` property will be `null`.
- **Error**: The request finished with an unexpected error in the plugin. The user defined callback will be called with a `null` response object. The request's `Exception` property may contain more info about the error, but it can be `null`.
- **Aborted**: The request aborted by the client(HTTPRequests `Abort()` function). The user defined callback will be called with a `null` response. The request’s `Exception` property will be `null`.
- **ConnectionTimedOut**: Connecting to the server timed out. The user defined callback will be called with a `null` response. The request’s Exception property will be `null`.
- **TimedOut**: The request didn't finished in the given time. The user defined callback will be called with a `null` response. The request’s Exception property will be `null`.
For a usage example see the previous section’s example.
