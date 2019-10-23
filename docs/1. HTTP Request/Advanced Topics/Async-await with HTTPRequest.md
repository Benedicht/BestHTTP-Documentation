# Async-Await with HTTPRequest

Starting in v1.12.0 new async APIs are added to the HTTPRequest. Async APIs are `GetHTTPResponseAsync`, `GetAsStringAsync`, `GetAsTexture2DAsync`, `GetRawDataAsync` and using LitJson from the Examples folder there's a `GetFromJsonResultAsync` too.

## Simple async-await Example

Simplest example to download a string using async-await:
```language-csharp
using System;
using System.Threading.Tasks;
using UnityEngine;
 
using BestHTTP;
 
public class AsyncTest : MonoBehaviour
{
    async Task Start()
    {
        var request = new HTTPRequest(new Uri("https://httpbin.org/get"));
 
        Debug.Log(await request.GetAsStringAsync());
    }
}
```

## Handling Errors

Any outcome that fails to resolve the expected outcome are going to throw an exception.

```language-csharp
try
{
    Debug.Log(await request.GetAsStringAsync(tokenSource.Token));
}
catch (Exception ex)
{
    Debug.LogException(ex);
}
```

Possible errors are various timeouts, status codes that indicate errors (401, 404 for example), request cancellation, etc.


## Using CancellationToken

Async APIs can accept a [CancellationToken](https://docs.microsoft.com/en-us/dotnet/api/system.threading.cancellationtoken?view=netstandard-2.0):

```language-csharp
using System;
using System.Threading;
using System.Threading.Tasks;
using UnityEngine;
 
using BestHTTP;
 
public class AsyncTest : MonoBehaviour
{
    async Task Start()
    {
        var request = new HTTPRequest(new Uri("https://httpbin.org/get"));
 
        CancellationTokenSource tokenSource = new CancellationTokenSource(TimeSpan.FromSeconds(10));
        try
        {
            Debug.Log(await request.GetAsStringAsync(tokenSource.Token));
        }
        catch(Exception ex)
        {
            Debug.LogException(ex);
        }
 
        // don't forget to dispose! ;)
        tokenSource.Dispose();
    }
}
```

When the token's cancellation take action, the plugin will call `Abort` on the `HTTPRequest` object.


## Configure Await

With [ConfigureAwait](https://docs.microsoft.com/en-us/dotnet/api/system.threading.tasks.task.configureawait?view=netstandard-2.0) the `Task` can be configured to continue its exetution on the completing thread. The example below with `ConfigureAwait(false)` should display two different thread ids. With `ConfigureAwait(true)`, thread ids should be the same.

```language-csharp
using System;
using System.Threading;
using System.Threading.Tasks;
using UnityEngine;
 
using BestHTTP;
 
public class AsyncTest : MonoBehaviour
{
    async Task Start()
    {
        var request = new HTTPRequest(new Uri("https://httpbin.org/get"));
 
        Debug.Log("Thread id before: " + Thread.CurrentThread.ManagedThreadId);
 
        string result = await request.GetAsStringAsync().ConfigureAwait(false);
 
        Debug.Log("Thread id after: " + Thread.CurrentThread.ManagedThreadId);

        Debug.Log("Result: " + result);
    }
}
```