#Upload Progress Tracking
To track and display upload progress you can use the OnUploadProgress event of the HTTPRequest class. The OnUploadProgress can be used with RawData, forms(through AddField and AddBinaryData) and with UploadStream too.

```csharp
var request = new HTTPRequest(new Uri(address), HTTPMethods.Post, OnFinished);
request.RawData =  Encoding.UTF8.GetBytes("Field Value");
request.OnUploadProgress = OnUploadProgress;
request.Send();

	void OnUploadProgress(HTTPRequest request, long uploaded, long length) {
		float progressPercent = (uploaded / (float)length) * 100.0f;
		Debug.Log("Uploaded: " + progressPercent.ToString("F2") + "%");
	}
```