#Statistics
You can get some statistics about the underlying plugin using the HTTPManager.GetGeneralStatistics function:

```csharp
GeneralStatistics stats = HTTPManager.GetGeneralStatistics(StatisticsQueryFlags.All);
Debug.Log(stats.ActiveConnections);
```

You can query for three types of statistics:

1. **Connections**: Connection based statistics will be returned. These are the following:

	- RequestsInQueue: Number of requests are waiting in the queue for a free connection.

	- Connections: The number of HTTPConnection instances that are tracked by the plugin. This is the sum of all of the following connections.

	- ActiveConnections: Number of active connections. These connections are currently processing a request.

	- FreeConnections: Number of free connections. These connections are finished with a request, and they are waiting for an another request or for recycling.

	- RecycledConnections: Number of recycled connections. These connections will be deleted as soon as possible.


	
2. **Cache**: Cache based statistics. These are the following:

	- CacheEntityCount: Number of cached responses.

	- CacheSize: Sum size of the cached responses.
	
	

3. **Cookie**: Cookie based statistics. These are the following:

	- CookieCount: Number of cookies in the Cookie Jar.

	- CookieJarSize: Sum size of the cookies in the Cookie Jar.
