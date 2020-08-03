# Timing API

A `HTTPRequest` tracks timings of various phases. These phases could be the following([naming and meaning similiar to the one can be found in the Chrome DevTools](https://developers.google.com/web/tools/chrome-devtools/network/reference?#timing-explanation)):

- **Queued**: Duration the plugin kept the request in its internal queue. Normally this should be a very low time, but when [MaxConnectionPerServer](../../7.GlobalTopics/GlobalSettings/) or HTTP/2's negotiated [MaxConcurrentStreams](../../7.GlobalTopics/HTTP2/#settings) applies requests could stay in the queue longer.
- **Queued for redirection**: The same as the previous, but the request already made a round-trip to a server and got redirected.
- **DNS Lookup**: Duration to resolve the server's IP address. Absent if the request processed on a reused connection.
- **TCP Connection**: Time required to connect to the server through a new TCP channel. Absent if the request processed on a reused connection.
- **Proxy Negotiation**: Time took to negotiate with the proxy. Absent if the request processed on a reused connection.
- **TLS Negotiation**: Duration of the TLS negotiation. Absent if the request processed on a reused connection.
- **Request Sent**: Time required to write all bytes of the request (headers + payload) to the network.
- **Waiting (TTFB)**: Time the plugin had to wait for the first byte of the server's response.
- **Headers**: Time required to read all headers.
- **Response Received**: Time required to read all bytes of the response's payload.
- **Loading from Cache**: Time required to read all bytes from a previously cached response. Absent for non-cached contents.
- **Writing to Cache**: Time took to cache the response. Absent for non-cachable contents.
- **Queued for Dispatch**: Time between the request is finished and its callback is called. Just like the Queued timings, the request shouldn't stay too much in this queue either. However, because callbacks are called from a MonoBehavior's Upate function, frequency of the Update calls greatly affects these numbers.
- **Finished in**: Duration from start to finish.

As noted, not all phases are present for all requests, but it's also true that new entries are addded for every redirection.

For example a request timing can look like this when it's a first request (no connection is reused):

> [TimingCollector Start: '12:42:56' </br>['Queued': 00:00:00.0030003]</br>['DNS Lookup': 00:00:00.0050012]</br>['TCP Connection': 00:00:00.0040004]</br>['Proxy Negotiation': 00:00:00.3006451]</br>['TLS Negotiation': 00:00:00.4023915]</br>['Queued': 00:00:00.0072776]</br>['Request Sent': 00:00:00.0139910]</br>['Waiting (TTFB)': 00:00:00.1346626]</br>['Headers': 00:00:00.0060009]</br>['Response Received': 00:00:00.0019991]</br>['Queued for Dispatch': 00:00:00.0020012]</br>['Finished in': 00:00:00.8809709]]


The code that produced this log entry:
```language-csharp
IEnumerator DoTiming()
{
    var request = new HTTPRequest(new Uri("https://httpbin.org/get"));
    yield return request.Send();

    Debug.Log(request.Timing.ToString());
}
```

As can be seen the three largest entries are *Proxy Negotiation*, *TLS Negotiation* and *Waiting (TTFB)*.

But, when a reques can be sent through an already open connection or using HTTP/2, running the code above can produce an entry like this:

>[TimingCollector Start: '12:49:48' </br>['Queued': 00:00:00]</br>['Request Sent': 00:00:00.0010005]</br>['Waiting (TTFB)': 00:00:00.1308247]</br>['Headers': 00:00:00]</br>['Response Received': 00:00:00]</br>['Queued for Dispatch': 00:00:00]</br>['Finished in': 00:00:00.1318252]]

Most of the time spent for waiting for the server's response.

!!! Warning
	Timing uses `DateTime.Now` to calculate time spent between the phases, accuracy depends on this call. It can be used to get a better view on where the plugin had to wait or spend time and **not** for benchmarking!
	