---
title: Small Code Samples
sidebar: best_http2_main_sidebar
---

## Upload a picture using forms

```csharp
var request = new HTTPRequest(new Uri("http://server.com"), HTTPMethods.Post, onFinished);

request.AddBinaryData("image", texture.EncodeToPNG(), "image.png", "image/png");

request.Send();
```

## Upload a picture without forms, sending only the raw data

```csharp
var request = new HTTPRequest(new Uri("http://server.com"), HTTPMethods.Post, onFinished);

request.SetHeader("Content-Type", "image/png");
request.RawData = texture.EncodeToPNG();

request.Send();
```

## Send json data

```csharp
string json = "{ 'field': 'value' }";

var request = new HTTPRequest(new Uri("http://server.com"), HTTPMethods.Post, onFinished);

request.SetHeader("Content-Type", "application/json; charset=UTF-8");
request.RawData = System.Text.Encoding.UTF8.GetBytes(json);

request.Send();
```

## Display download progress

```csharp
var request = new HTTPRequest(new Uri("http://serveroflargefile.net/path"), (req, resp) => {
  Debug.Log("Finished!");
});

request.OnDownloadProgress += (req, down, length) => Debug.Log(string.Format("Progress: {0:P2}", down / (float)length));

request.Send();
```

## Abort a request

```csharp
var request = new HTTPRequest(new Uri(address), (req, resp) => {
	// State should be HTTPRequestStates.Aborted if we call Abort() before
	// it’s finishes
	Debug.Log(req.State);
});

request.Send();

// and then call Abort when the request isn't relevant anymore
request.Abort();
```

## Get header values

```csharp
var request = new HTTPRequest(new Uri("https://httpbin.org/get"), (req, resp) =>
{
    // One response can contain multiple header: value pairs for the same 'header'.
    List<string> values = resp.GetHeaderValues("custom-header");
    foreach (string header in values)
        Debug.Log(header);

    // GetFirstHeaderValue returns the first header's value. It's good for headers that we are sure that occur only one per response.
    string contentLengthHeader = resp.GetFirstHeaderValue("content-length");
    Debug.Log(contentLengthHeader);
});

request.Send();
```

## Sending requests on application quit

```csharp
BestHTTP.HTTPUpdateDelegator.OnBeforeApplicationQuit += () =>
{
    // Unsubscribe, so next time we will truly quit
    BestHTTP.HTTPUpdateDelegator.OnBeforeApplicationQuit = null;

    // Cancel the current quitting
    UnityEngine.Application.CancelQuit();

    // TODO: send out HTTP request, etc.

    // Return false, so BestHTTP will not shut down itself
    return false;
};
```