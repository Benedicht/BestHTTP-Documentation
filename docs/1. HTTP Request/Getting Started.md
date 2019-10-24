#Getting Started Quickly

After you imported the package, you should add a using statement to your source file like any other regular usings:

```	
using BestHTTP;
```

##GET Requests
The simplest way to do a request to a web server is to create a `HTTPRequest` object providing the url and a callback function to it's constructor. After we constructed a new `HTTPRequest` object the only thing we need to do, is actually send the request with the Send() function. Let's see an example:

```language-csharp
HTTPRequest request = new HTTPRequest(new Uri("https://google.com"), OnRequestFinished);
request.Send();
```

The OnRequestFinished() function's implementation might be this:

```language-csharp
void OnRequestFinished(HTTPRequest request, HTTPResponse response)
{
	Debug.Log("Request Finished! Text received: " + response.DataAsText);
}
```

As you can see the callback function always receives the original `HTTPRequest` object and an `HTTPResponse` object that holds the response from the server. The `HTTPResponse` object is `null` if there were an error and the request object has an `Exception` property that might carry extra information about the error if there were any.

While the requests are always processed on separate threads, calling the callback function is done on Unity's main thread, so we don't have to do any thread synchronization.

If we want to write more compact code we can use c#'s lambda expressions. In this example we don't even need a temporary variable:

```language-csharp
new HTTPRequest(new Uri("https://google.com"), (request, response) => Debug.Log("Finished!"))
	.Send();
```

!!! Notice
	Error handling is omitted for brevity in most of the samples through the documentation, but there's a complete section dedicated to [error handling](Advanced Topics/Error Handling.md).

##POST Requests
The above examples were simple GET requests. If we don’t specify the method, all requests will be GET requests by default. The constructor has another parameter that can be used to specify the method of the request:

```language-csharp
HTTPRequest request = new HTTPRequest(new Uri("http://server.com/path"), HTTPMethods.Post, OnRequestFinished);
request.AddField("FieldName", "Field Value");
request.Send();
```

To POST any data without setting a field you can use the `RawData` property:

```language-csharp
HTTPRequest request = new HTTPRequest(new Uri("http://server.com/path"), HTTPMethods.Post, OnRequestFinished);
request.RawData =  Encoding.UTF8.GetBytes("Field Value");
request.Send();
```

For additional samples check out the [Small Code-Samples section](Advanced Topics\Small Code-Samples.md).

Beside GET and POST you can use the HEAD, PUT, DELETE and PATCH methods as well:

##Head Requests

```language-csharp
HTTPRequest request = new HTTPRequest(new Uri("http://server.com/path"), HTTPMethods.Head, OnRequestFinished);
request.Send();
```

##Put Requests

```language-csharp
HTTPRequest request = new HTTPRequest(new Uri("http://server.com/path"), HTTPMethods.Put, OnRequestFinished);
request.Send();
```
##Delete Requests

```language-csharp
HTTPRequest request = new HTTPRequest(new Uri("http://server.com/path"), HTTPMethods.Delete, OnRequestFinished);
request.Send();
```

##Patch Requests

```language-csharp
HTTPRequest request = new HTTPRequest(new Uri("http://server.com/path"), HTTPMethods.Patch, OnRequestFinished);
request.Send();
```

##How To Access The Downloaded Data
Most of the time we use our requests to receive some data from a server. The raw bytes can be accessed from the `HTTPResponse` object's `Data` property. Let's see an example how to download an image:

```language-csharp
new HTTPRequest(new Uri("http://yourserver.com/path/to/image.png"), (request, response) =>
{
	var tex = new Texture2D(0, 0);
	tex.LoadImage(response.Data);
	guiTexture.texture = tex;
}).Send();
```

Beside of `DataAsTexture2D` there is a `DataAsText` property too to decode the response as an Utf8 string.

!!! Warning
	All examples in this document are without any error checking! See the [Error Handling topic](Advanced Topics/Error Handling.md)!
