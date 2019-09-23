#Control Redirections
Redirection are handled automatically by the plugin, but sometimes we have to make changes before a new request is made to the uri that we redirected to. We can do these changes in the `OnBeforeRedirection` event handler of a `HTTPRequest`.
This event is called before the plugin will do a new request to the new uri. The return value of the function will control the redirection: if it's false the redirection is aborted.

This function is called on a thread other than the main Unity thread!

```csharp
var request = new HTTPRequest(uri, HTTPMethods.Post);
request.AddField("field", "data");
request.OnBeforeRedirection += OnBeforeRedirect;
request.Send();

bool OnBeforeRedirect(HTTPRequest req, HTTPResponse resp, Uri redirectUri)
{
   if (req.MethodType == HTTPMethods.Post && resp.StatusCode == 302)
   {
  	 req.MethodType = HTTPMethods.Get;

  	 // Don't send more data than needed.
	 // So we will delete our already processed form data.
  	 req.Clear();
   }

   return true;
}
```
