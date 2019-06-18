#Getting Started Quickly

First, you should add a using statement to your source file after the regular usings:

```	
using BestHTTP;
```

##GET Requests
The simplest way to do a request to a web server is to create a HTTPRequest object providing the url and a callback function to it's constructor. After we constructed a new HTTPRequest object the only thing we need to do, is actually send the request with the Send() function. Let's see an example:

```csharp
HTTPRequest request = new HTTPRequest(new Uri("https://google.com"), OnRequestFinished);
request.Send();
```

The OnRequestFinished() function's implementation might be this:

```csharp
void OnRequestFinished(HTTPRequest request, HTTPResponse response)
{
Debug.Log("Request Finished! Text received: " + response.DataAsText);
}
```

As you can see the callback function always receives the original HTTPRequest object and an HTTPResponse object that holds the response from the server. The HTTPResponse object is null if there were an error and the request object has an Exception property that might carry extra information about the error if there were any.

While the requests are always processed on separate threads, calling the callback function is done on Unity's main thread, so we don't have to do any thread synchronization.

If we want to write more compact code we can use c#'s lambda expressions. In this example we don't even need a temporary variable:

```csharp
new HTTPRequest(new Uri("https://google.com"), (request, response) =>
Debug.Log("Finished!")).Send();
```

##POST Requests
The above examples were simple GET requests. If we don’t specify the method, all requests will be GET requests by default. The constructor has another parameter that can be used to specify the method of the request:

```csharp
HTTPRequest request = new HTTPRequest(new Uri("http://server.com/path"), HTTPMethods.Post,
OnRequestFinished);
request.AddField("FieldName", "Field Value");
request.Send();
```

To POST any data without setting a field you can use the **RawData** property:

```csharp
HTTPRequest request = new HTTPRequest(new Uri("http://server.com/path"), HTTPMethods.Post,
OnRequestFinished);
request.RawData =  Encoding.UTF8.GetBytes("Field Value");
request.Send();
```

For additional samples check out the Small Code-Samples section.

Beside GET and POST you can use the HEAD, PUT, DELETE and PATCH methods as well:

##Head Requests

```csharp
HTTPRequest request = new HTTPRequest(new Uri("http://server.com/path"), HTTPMethods.Head,
OnRequestFinished);
request.Send();
```

##Put Requests

```csharp
HTTPRequest request = new HTTPRequest(new Uri("http://server.com/path"), HTTPMethods.Put,
OnRequestFinished);
request.Send();
```
##Delete Requests

```csharp
HTTPRequest request = new HTTPRequest(new Uri("http://server.com/path"), HTTPMethods.Delete,
OnRequestFinished);
request.Send();
```

##Patch Requests

```csharp
HTTPRequest request = new HTTPRequest(new Uri("http://server.com/path"), HTTPMethods.Patch,
OnRequestFinished);
request.Send();
```

##How To Access The Downloaded Data
Most of the time we use our requests to receive some data from a server. The raw bytes can be accessed from the HTTPResponse object's Data property. Let's see an example how to download an image:

```csharp
new HTTPRequest(new Uri("http://yourserver.com/path/to/image.png"), (request, response) =>
{
var tex = new Texture2D(0, 0);
tex.LoadImage(response.Data);
guiTexture.texture = tex;
}).Send();
```

Of course there is a more compact way to do this:

```csharp
new HTTPRequest(new Uri("http://yourserver.com/path/to/image.png"), (request, response) =>
guiTexture.texture = response.DataAsTexture2D).Send();
```

Beside of DataAsTexture2D there is a **DataAsText** property to decode the response as an Utf8 string. More data decoding properties may be added in the future. If you have an idea don't hesitate to mail me.

!!! Warning "Warning:"
	All examples in this document are without any error checking! In the production code make sure to add some null checks.


##Switching from WWW
You can yield a HTTPRequest with the help of a StartCoroutine call:

```csharp
HTTPRequest request = new HTTPRequest(new Uri("http://server.com"));
request.Send();
yield return StartCoroutine(request);
Debug.Log("Request finished! Downloaded Data:" + request.Response.DataAsText);
```

The Debug.Log will be called only when the request is done. This way you don’t have to supply a callback function (however, you still can if you want to).
