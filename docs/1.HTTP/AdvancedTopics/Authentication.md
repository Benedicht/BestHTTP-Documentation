# Authentication
Best HTTP supports Basic and Digest authentication through the HTTPRequest’s Credentials property:


```language-csharp
using BestHTTP;
using BestHTTP.Authentication;

var request = new HTTPRequest(new Uri("http://yourserver.org/auth-path"), (req, resp) => {
	if (resp.StatusCode != 401)
		Debug.Log("Authenticated");
	else
		Debug.Log("NOT Authenticated");
});

request.Credentials = new Credentials("usr", "paswd");
request.Send(); 
```
