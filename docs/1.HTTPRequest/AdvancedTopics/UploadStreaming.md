#Upload Streaming
You can set a Stream instance to upload to a HTTPRequest object through the UploadStream property. The plugin will use this stream to gather data to send to the server. When the upload finished and the DisposeUploadStream is true, then the plugin will call the Dispose() function on the stream.
If the stream’s length is unknown, the UseUploadStreamLength property should be set to false. In this case, the plugin will send the data from the stream with chunked Transfer-Encoding.

```language-csharp
var request = new HTTPRequest(new Uri(address), HTTPMethods.Post, OnUploadFinished);
request.UploadStream = new FileStream("File_To.Upload", FileMode.Open);
request.Send();
```
