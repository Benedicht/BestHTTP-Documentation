#Caching
Caching is based on the HTTP/1.1 RFC too. It’s using the headers to store and validate the response. The caching mechanism is working behind the scenes, the only thing we have to do is to decide if we want to enable or disable it.
If the cached response has an ‘Expires’ header with a future date, BestHTTP will use the  cached response without validating it with the server. This means that we don’t have to initiate any tcp connection to the server. This can save us time, bandwidth and **works offline** as well.

Although caching is automatic we have some control over it, or we can gain some info using the public functions of the HTTPCacheService class:

- **BeginClear()**: It will start clearing the entire cache on a separate thread.
- **BeginMaintainence()**: With this function’s help, we can delete cached entries based on the last access time. It deletes entries that’s last access time is older than the specified time. We can also use this function to keep the cache size under control:

```csharp
// Delete cache entries that weren’t accessed in the last two weeks, then
// delete entries to keep the size of the cache under 50 megabytes, starting with the oldest.
HTTPCacheService.BeginMaintainence(new HTTPCacheMaintananceParams(TimeSpan.FromDays(14),
50 * 1024 * 1024));
```


- **GetCacheSize()**: Will return the size of the cache in bytes.
- **GetCacheEntryCount()**: Will return the number of the entries stored in the cache. The average cache entry size can be computed with the `float avgSize = GetCacheSize() / (float) GetCacheEntryCount()` formula.
