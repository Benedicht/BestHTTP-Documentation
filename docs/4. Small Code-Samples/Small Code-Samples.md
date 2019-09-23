#Small Code-Samples

- **Upload a picture using forms**

```csharp
var request = new HTTPRequest(new Uri("http://server.com"), HTTPMethods.Post, onFinished);
request.AddBinaryData("image", texture.EncodeToPNG(), "image.png");
request.Send();
```

- **Upload a picture without forms, sending only the raw data**

```csharp
var request = new HTTPRequest(new Uri("http://server.com"), HTTPMethods.Post, onFinished);
request.SetHeader("Content-Type", "image/png");
request.Raw = texture.EncodeToPNG();
request.Send();
```

- **Add custom header**

```csharp
string json = "{ }";

var request = new HTTPRequest(new Uri("http://server.com"), HTTPMethods.Post, onFinished);
request.SetHeader("Content-Type", "application/json; charset=UTF-8");
request.RawData = UTF8.Encoding.GetBytes(json);
request.Send();
```

- **Display download progress**

```csharp
var request = new HTTPRequest(new Uri("http://serveroflargefile.net/path"), (req, resp) => {
  Debug.Log("Finished!");
});

request.OnProgress += (req, down, length) => Debug.Log(string.Format("Progress: {0:P2}", down / (float)length));
request.Send();
```

- **Abort a request**

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

- **Range request for resumable download**
First request is a Head request to get the server capabilities. When range requests are supported the DownloadCallback function will be called. In this function we will create a new real request to get chunks of the content with setting the callback function to this function too. The current download position saved to the PlayerPrefs, so the download can be resumed even after an application restart.

```csharp
private const int ChunkSize = 1024 * 1024; // 1 MiB - should be bigger!
private string saveTo = "downloaded.bin";

void StartDownload(string url)
{
  // This is a HEAD request, to get some information from the server
  var headRequest = new HTTPRequest(new Uri(url), HTTPMethods.Head, (request, response) => {
		if (response == null)
			Debug.LogError("Response null. Server unreachable? Try again later.");
		else
		{
			if (response.StatusCode == 416)
				Debug.LogError("Requested range not satisfiable");
			else if (response.StatusCode == 200)
				Debug.LogError("Partial content doesn't supported by the server, content can be downloaded as a whole.");
			else if (response.HasHeaderWithValue("accept-ranges", "none"))
				Debug.LogError("Server doesn't supports the 'Range' header! The file can't be downloaded in parts.");
			else
				DownloadCallback(request, response);
		}
	});

  // Range header for our head request
  int startPos = PlayerPrefs.GetInt("LastDownloadPosition", 0);
  headRequest.SetRangeHeader(startPos, startPos + ChunkSize);

  headRequest.DisableCache = true;
  headRequest.Send();
}

void DownloadCallback(HTTPRequest request, HTTPResponse response)
{
  if (response == null)
  {
 	 Debug.LogError("Response null. Server unreachable, or connection lost? Try again later.");
 	 return;
  }

  var range = response.GetRange();

  if (range == null)
  {
 	 Debug.LogError("No 'Content-Range' header returned from the server!");
 	 return;
  }
  else if (!range.IsValid)
  {
 	 Debug.LogError("No valid 'Content-Range' header returned from the server!");
 	 return;
  }

  // Save(append) the downloaded data to our file.
  if (request.MethodType != HTTPMethods.Head)
  {
 	 string path = Path.Combine(Application.temporaryCachePath, saveTo);
	 using (FileStream fs = new FileStream(path, FileMode.Append))
 		 fs.Write(response.Data, 0, response.Data.Length);

 	 // Save our position
 	 PlayerPrefs.SetInt("LastDownloadPosition", range.LastBytePos);

 	 // Some debug output
 	 Debug.LogWarning(string.Format("Download Status: {0}-{1}/{2}", range.FirstBytePos, range.LastBytePos, range.ContentLength));

 	 // All data downloaded?
 	 if (range.LastBytePos == range.ContentLength - 1)
 	 {
 		 Debug.LogWarning("Download finished!");
 		 return;
 	 }
  }

  // Create the real GET request.
  // The callback function is the function that we are currently in!
  var downloadRequest = new HTTPRequest(request.Uri, HTTPMethods.Get, /*isKeepAlive:*/ true, DownloadCallback);

  // Set the next range's position.
  int nextPos = 0;
  if (request.MethodType != HTTPMethods.Head)
 	 nextPos = range.LastBytePos + 1;
  else
 	 nextPos = PlayerPrefs.GetInt("LastDownloadPosition", 0);

  // Set up the Range header
  downloadRequest.SetRangeHeader(nextPos, nextPos + ChunkSize);

  downloadRequest.DisableCache = true;

  // Send our new request
  downloadRequest.Send();
}
```

This is just one implementation. The other would be that start a streamed download, save the chunks and when a failure occurred try again with the starting range as the saved file’s size.
