#Request Priority
Request’s priority can be changed through the HTTPRequest’s Priority property. Higher priority requests will be picked from the request queue sooner than lower priority requests.

```csharp
var request = new HTTPRequest(new Uri("https://google.com"), ...);
request.Priority = -1;
request.Send();
```
