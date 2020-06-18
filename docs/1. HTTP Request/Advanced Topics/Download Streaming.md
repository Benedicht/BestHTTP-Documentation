# Download Streaming

!!! Warning
	Not available under the WebGL runtime. See [platforms and limitations section for more details](../../platforms.md)

For larger responses it's not advised to keep the whole entity in memory. To be able process downloaded data as soon as received the plugin provides the `OnStreamingData` callback. 
```language-csharp
var request = new HTTPRequest(new Uri("..."), OnRequestFinished);
request.OnStreamingData += OnDataDownloaded;

bool OnDataDownloaded(HTTPRequest request, HTTPResponse response, byte[] dataFragment, int dataFragmentLength)
{
    // Use downloaded data
	
    return true;
}
```

The callback's parameters are the following:

- **request**: the original `HTTPRequest` object
- **response**: the `HTTPResponse` object the data belongs to. Through this object all already received information can be accessed (status code, headers, etc.)
- **dataFragment**: the actual downloaded bytes. Because the plugin reuses byte arrays, its length can be larger than the downloaded data, so instead of `dataFragment.Length` the `dataFragmentLength` parameter must be used!
- **dataFragmentLength**: the real downloaded byte count of the dataFragment parameter. Use this parameter instead of `dataFragment.Length`!

The callback also must return `true` or `false` depending on whether the plugin can reuse the `dataFragment` buffer or not. For more details see the [BufferPool documentation](../../7. Global Topics/BufferPool.md).
So in case the dataFragment's reference is kept by user code, the callback must return false:

```language-csharp
var request = new HTTPRequest(new Uri("..."), OnRequestFinished);
request.OnStreamingData += OnDataDownloaded;

List<Data> dataToProcess = new List<Data>();
bool OnDataDownloaded(HTTPRequest request, HTTPResponse response, byte[] dataFragment, int dataFragmentLength)
{
	// dataFragment is saved to process it later
    dataToProcess.Add(new Data { 
		buffer = dataFragment, 
		length = dataFragmentLength 
	});
	
	// so the callback must return false, otherwise the plugin would reuse the byte[] overwriting the data in it
    return false;
}

struct Data
{
	public byte[] buffer;
	public int length;
}
```

Size of the `dataFragment` (== `dataFragmentLength`) depends on various factors:

1. Value of the `StreamFragmentSize` property. The plugin tries to keep the fragments' size around `StreamFragmentSize`, but the BufferPool can return a larger chunks of memory.
2. If `StreamChunksImmediately` is `true`, then no buffering will be done. In case of chunked content-encoding the size of the fragment is the chunk length. In case there's a content-length header, the plugin fills up an at least `HTTPResponse.MinBufferSize`d buffer for the next fragment.

Because there's a time window between producing dataFragments and consuming them in an `OnStreamingData` callback, to prevent consuming too much memory there's a hard limit on the queued dataFragments. When this hard limit is reached the reader thread stops producing new fragments and resumes as soon as there's free slots in the queue. This hard limit can be changed through the `MaxFragmentQueueLength` property. So, the maximum amount of memory the plugin will consme for streaming is about (`MaxFragmentQueueLength` * `StreamFragmentSize`).<br>
With HTTP/2, the reading thread doesn't know the semantics of the frames it reads from the stream, so it can't limit what and how many frames/data it reads (it would also block the reading of other frames too). To limit a HTTP/2 stream and/or the whole HTTP/2 connection [`HTTPManager.HTTP2Settings`](../../7. Global Topics/HTTP2.md)' `InitialStreamWindowSize` and `InitialConnectionWindowSize` can be used.

## Streaming into a file

In the following example the `FileStream` is created on-demand and its reference is stored in the request's Tag property to reuse the instance instead of reopening the file every time.

```language-csharp
var request = new HTTPRequest(new Uri(url), OnRequestFinished);

request.OnStreamingData += OnData;

request.Send();

private bool OnData(HTTPRequest req, HTTPResponse resp, byte[] dataFragment, int dataFragmentLength)
{
    if (resp.IsSuccess)
    {
        var fs = req.Tag as System.IO.FileStream;
        if (fs == null)
            req.Tag = fs = new System.IO.FileStream("fileName", System.IO.FileMode.Create);

        fs.Write(dataFragment, 0, dataFragmentLength);
    }

    // Return true if dataFragment is processed so the plugin can recycle it
    return true;
}

private void OnRequestFinished(HTTPRequest req, HTTPResponse resp)
{
    var fs = req.Tag as System.IO.FileStream;
    if (fs != null)
        fs.Dispose();

    switch (req.State)
    {
        // The request finished without any problem.
        case HTTPRequestStates.Finished:
            if (resp.IsSuccess)
            {
                Debug.Log("Done!");
            }
            else
            {
                Debug.LogWarning(string.Format("Request finished Successfully, but the server sent an error. Status Code: {0}-{1} Message: {2}",
                                                resp.StatusCode,
                                                resp.Message,
                                                resp.DataAsText));
            }
            break;

        default:
                // There were an error while downloading the content.
                // The incomplete file should be deleted.
                System.IO.File.Delete("filename");
            break;
    }
}
```