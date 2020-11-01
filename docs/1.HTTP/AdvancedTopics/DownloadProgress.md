# Download Progress Tracking
To track and display download progress you can use the `OnDownloadProgress` event of the `HTTPRequest` class. This event’s parameters are the original `HTTPRequest` object, the downloaded bytes and the expected length of the downloaded content.

```language-csharp
var request = new HTTPRequest(new Uri(address), OnFinished);
request.OnDownloadProgress = OnDownloadProgress;
request.Send();

void OnDownloadProgress(HTTPRequest request, long downloaded, long length) {
	float progressPercent = (downloaded / (float)length) * 100.0f;
	Debug.Log("Downloaded: " + progressPercent.ToString("F2") + "%");
}
```

!!! Warning
	When the server sends the content with chunked encoding the plugin can't determine what will be the final length so length will be advanced by the current chunk's length.