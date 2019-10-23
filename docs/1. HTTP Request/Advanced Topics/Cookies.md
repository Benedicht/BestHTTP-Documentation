#Cookies
Handling of cookie operations are transparent to the programmer. Setting up the request Cookie header and parsing and maintaining the response's Set-Cookie header are done automatically by the plugin.
However it can be controlled in various ways:
It can be disabled per-request or globally by setting the `HTTPRequest` object's `IsCookiesEnabled` property or the `HTTPManager.IsCookiesEnabled` property.
Cookies can be deleted from the Cookie Jar by calling the `CookieJar.Clear()` function.
New cookies that are sent from the server can be accessed through the response's `Cookies` property.
There are numerous global setting regarding cookies. See the [Global Settings](Global Settings.md) section for more information.

Cookies can be added to a `HTTPRequest` by adding them to the Cookies list:

```language-csharp
var request = new HTTPRequest(new Uri(address), OnFinished);
request.Cookies.Add(new Cookie("Name", "Value"));
request.Send();
``` 

These cookies will be merged with the server sent cookies. If `IsCookiesEnabled` is set to false on the request or in the `HTTPManager`, then only these user-set cookies will be sent.
