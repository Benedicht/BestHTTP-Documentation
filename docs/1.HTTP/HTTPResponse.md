## Properties

- `int VersionMajor`: Major version number of this response received with. With HTTP/1.1 it's going to be `1`, and with HTTP/2 it's `2`.
- `int VersionMinor`: Minor version number of this response received with. With HTTP/1.1 it's going to be `1`, and with HTTP/2 it's `0`.
- `int StatusCode`: The status code that sent from the server.
- `bool IsSuccess`: Returns true if the status code is in the range of [200..300[ or 304 (Not Modified)
- `string Message`: The message that sent along with the StatusCode from the server. You can check it for errors from the server.
- `bool IsStreamed`: True if it's a streamed response.
- `bool IsFromCache`: Indicates that the response body is read from the cache.
- `HTTPCacheFileInfo CacheFileInfo`: Provides information about the file used for caching the request.
- `bool IsCacheOnly`: Determines if this response is only stored to cache. If both IsCacheOnly and IsStreamed are true, OnStreamingData isn't called.
- `bool IsProxyResponse`: True, if this is a response for a HTTPProxy request.
- `Dictionary<string, List<string>> Headers`: The headers that sent from the server.
- `byte[] Data`: The data that downloaded from the server. All Transfer and Content encodings decoded if any(eg. chunked, gzip, deflate).
- `bool IsUpgraded`: The normal HTTP protocol is upgraded to an other.
- `List<Cookie> Cookies`: The cookies that the server sent to the client.
- `string DataAsText`: The data converted to an UTF8 string.
- `Texture2D DataAsTexture2D`: The data loaded to a Texture2D.
- `bool IsClosedManually`: True if the connection's stream will be closed manually. Used in custom protocols (WebSocket, EventSource).
- `LoggingContext Context`: [Logging context](../7.GlobalTopics/Logging.md#LoggingContext) of the request.

## Functions

- `List<string> GetHeaderValues(string name)`: Returns the list of values that received from the server for the given header name. *Remarks: All headers converted to lowercase while reading the response.* If no header found with the given name or there are no values in the list (eg. Count == 0) returns null.
- `string GetFirstHeaderValue(string name)`: Returns the first value in the header list or null if there are no header or value. If no header found with the given name or there are no values in the list (eg. Count == 0) returns null.
- `bool HasHeaderWithValue(string headerName, string value)`: Checks if there is a header with the given name and value. Returns true if there is a header with the given name and value.
- `bool HasHeader(string headerName)`: Checks if there is a header with the given name. Returns true if there is a header with the given name.
- `HTTPRange GetRange()`: Parses the 'Content-Range' header's value and returns a HTTPRange object. If the server ignores a byte-range-spec because it is syntactically invalid, the server SHOULD treat the request as if the invalid Range header field did not exist. (Normally, this means return a 200 response containing the full entity). In this case because of there are no 'Content-Range' header, this function will return null! Returns null if no 'Content-Range' header found.