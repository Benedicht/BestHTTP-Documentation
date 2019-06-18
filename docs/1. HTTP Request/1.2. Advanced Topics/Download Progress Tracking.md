#Download Progress Tracking
To track and display download progress you can use the `OnProgress` event of the `HTTPRequest` class. This event’s parameters are the original `HTTPRequest` object, the downloaded bytes and the expected length of the downloaded content.

```csharp	
var request = new HTTPRequest(new Uri(address), OnFinished);
request.OnProgress = OnDownloadProgress;
request.Send();

	void OnDownloadProgress(HTTPRequest request, long downloaded, long length) {
		float progressPercent = (downloaded / (float)length) * 100.0f;
		Debug.Log("Downloaded: " + progressPercent.ToString("F2") + "%");
	}
```