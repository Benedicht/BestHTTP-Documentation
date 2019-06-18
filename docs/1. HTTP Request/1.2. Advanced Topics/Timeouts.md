#Timeouts
You can set two timeout for a request:

- **ConnectTimeout**: With this property you can control how much time you want to wait for a connection to be made between your app and the remote server. Its default value is 20 seconds.

```csharp
request = new HTTPRequest(new Uri("http://yourserver.com/"), (req, resp) => { … });
request.ConnectTimeout = TimeSpan.FromSeconds(2);
request.Send();
```

- **Timeout**: With this property you can control how much time you want to wait for a request to be processed(sending the request, and downloading the response). Its default value is 60 seconds.

```csharp
request = new HTTPRequest(new Uri("http://yourserver.com/"), (req, resp) => { … });
request.Timeout = TimeSpan.FromSeconds(10);
request.Send();
```

A more complete example:

```csharp
string url = "http://besthttp.azurewebsites.net/api/LeaderboardTest?from=0&count=10";
HTTPRequest request = new HTTPRequest(new Uri(url), (req, resp) =>
  {
 	 switch (req.State)
 	 {
 		 // The request finished without any problems.
 		 case HTTPRequestStates.Finished:
 			 Debug.Log("Request Finished Successfully!\n" + resp.DataAsText);
 			 break;

 		 // The request finished with an unexpected error.
// The request's Exception property may contain more information about the error.
 		 case HTTPRequestStates.Error:
 			 Debug.LogError("Request Finished with Error! " +
(req.Exception != null ?
(req.Exception.Message + "\n" + req.Exception.StackTrace) :
"No Exception"));
 			 break;

 		 // The request aborted, initiated by the user.
 		 case HTTPRequestStates.Aborted:
 			 Debug.LogWarning("Request Aborted!");
 			 break;

 		 // Connecting to the server timed out.
 		 case HTTPRequestStates.ConnectionTimedOut:
 			 Debug.LogError("Connection Timed Out!");
 			 break;

 		 // The request didn't finished in the given time.
 		 case HTTPRequestStates.TimedOut:
 			 Debug.LogError("Processing the request Timed Out!");
 			 break;
 	 }
  });

// Very little time, for testing purposes:
//request.ConnectTimeout = TimeSpan.FromMilliseconds(2);
request.Timeout = TimeSpan.FromSeconds(5);
request.DisableCache = true;
request.Send();
```