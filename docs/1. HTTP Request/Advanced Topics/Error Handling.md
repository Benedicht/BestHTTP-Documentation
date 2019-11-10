## Error handling

Because `HTTPResponse` in the callback can be null in cases where there were an error on client side (request aborting, timeouts or non-reachable server), as a best practice a `HTTPRequest`'s callback should look like this:

```language-csharp
private void OnRequestFinished(HTTPRequest req, HTTPResponse resp)
{
    switch (req.State)
    {
        // The request finished without any problem.
        case HTTPRequestStates.Finished:
            if (resp.IsSuccess)
            {
                // Everything went as expected!
            }
            else
            {
                Debug.LogWarning(string.Format("Request finished Successfully, but the server sent an error. Status Code: {0}-{1} Message: {2}",
                                                resp.StatusCode,
                                                resp.Message,
                                                resp.DataAsText));
            }
            break;

        // The request finished with an unexpected error. The request's Exception property may contain more info about the error.
        case HTTPRequestStates.Error:
            Debug.LogError("Request Finished with Error! " + (req.Exception != null ? (req.Exception.Message + "\n" + req.Exception.StackTrace) : "No Exception"));
            break;

        // The request aborted, initiated by the user.
        case HTTPRequestStates.Aborted:
            Debug.LogWarning("Request Aborted!");
            break;

        // Connecting to the server is timed out.
        case HTTPRequestStates.ConnectionTimedOut:
            Debug.LogError("Connection Timed Out!");
            break;

        // The request didn't finished in the given time.
        case HTTPRequestStates.TimedOut:
            Debug.LogError("Processing the request Timed Out!");
            break;
    }
}
```

A request may fail even before reaching the server so it's wise to check its `State` first. 
But even if the request reach the server it can fail if the request is badly constructed or incomplete (status code of 4xxx), or because the server had an issue (status code of 5xxx). So in the `Finshed` case we still have to check the `HTTPResponse`'s StatusCode for those codes, or just simple test against the `IsSuccess` property. IsSuccess is just a shortened way to check whether the status code is in a valid range:
```language-csharp
public bool IsSuccess { get { return (this.StatusCode >= 200 && this.StatusCode < 300) || this.StatusCode == 304; } }
```