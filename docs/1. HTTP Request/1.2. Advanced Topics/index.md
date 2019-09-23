# Advanced Topics
This section will cover some of the advanced usage that can be done with a `HTTPRequest`.

We can easily enable and disable **some** basic features with the help of the `HTTPRequest` class’ constructor. These parameters are the following:

- **methodType**: What kind of request we will send to the server. The default methodType is **HTTPMethods.Get**.
- **isKeepAlive**: Indicates to the server that we want the tcp connection to stay open, so consecutive http requests doesn’t need to establish the connection again. If we leave it to the default true, it can save us a lot of time. If we know that we won’t use requests that often we might set it to false. The default value is **true**.
- **disableCache**: Tells to the BestHTTP system to use or skip entirely the caching mechanism. If its value is true the system will not check the cache for a stored response and the response won’t get saved neither. The default value is **false**.

