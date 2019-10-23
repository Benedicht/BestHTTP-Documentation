#Aborting a Request
You can abort an ongoing request by calling the `HTTPRequest` object’s `Abort()` function:

```language-csharp
request = new HTTPRequest(new Uri("http://yourserver.com/bigfile"), (req, resp) => { … });
request.Send();

// And after some time:
request.Abort();
```

The callback function will be called and the response object will be `null`.
