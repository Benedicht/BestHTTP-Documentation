#Download Streaming
By default the callback function we provide to the HTTPRequest’s constructor will be called only once, when the server’s answer is fully downloaded and processed. This way, if we’d like to download a bigger file we’d quickly run out of memory on a mobile device. Our app would crash, users would be mad at us and the app would get a lot of bad rating. And rightfully so.
To avoid this, BestHTTP is designed to handle this problem very easily: with only switching one flag to true, our callback function will be called every time when a predefined amount of data is downloaded.
Additionally if we didn’t turn off caching, the downloaded response will be cached so next time we can stream the whole response from our local cache without any change to our code and without even touching the web server.

!!! Warning "Notes:" 
	The server must send valid caching headers ("Expires" header: see the [RFC](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.21 "RFC")) to allow this.

Lets see a quick example:

```csharp
var request = new HTTPRequest(new Uri("http://yourserver.com/bigfile"), (req, resp) =>
{
List<byte[]> fragments = resp.GetStreamedFragments();

if (resp.IsSuccess) // only create file for successful response
{
// Write out the downloaded data to a file:
using (FileStream fs = new FileStream("pathToSave", FileMode.Append))
foreach(byte[] data in fragments)
fs.Write(data, 0, data.Length);
}

if (resp.IsStreamingFinished)
Debug.Log("Download finished!");
});
request.UseStreaming = true;
request.StreamFragmentSize = 1 * 1024 * 1024; // 1 megabyte
request.DisableCache = true; // already saving to a file, so turn off caching
request.Send(); 
```

So what just happened above?


- We switched the flag - UseStreaming - to true, so our callback may be called more than one time.
- The StreamFragmentSize indicates the maximum amount of data we want to buffer up before our callback will be called.
- Our callback will be called every time when our StreamFragmentSize sized chunk is downloaded, and one more time when the IsStreamingFinished set to true.
- To get the downloaded data we have to use the GetStreamedFragments() function. We should save its result in a temporary variable, because the internal buffer is cleared in this call, so consecutive calls will give us null results.
- We disabled the cache in this example because we already saving the downloaded file and we don’t want to take too much space.

