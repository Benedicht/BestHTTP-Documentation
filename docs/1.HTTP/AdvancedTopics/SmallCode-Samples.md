# Small Code-Samples

## Upload a picture using forms

```language-csharp
var request = new HTTPRequest(new Uri("http://server.com"), HTTPMethods.Post, onFinished);

request.AddBinaryData("image", texture.EncodeToPNG(), "image.png", "image/png");

request.Send();
```

## Upload a picture without forms, sending only the raw data

```language-csharp
var request = new HTTPRequest(new Uri("http://server.com"), HTTPMethods.Post, onFinished);

request.SetHeader("Content-Type", "image/png");
request.RawData = texture.EncodeToPNG();

request.Send();
```

## Send json data

```language-csharp
string json = "{ 'field': 'value' }";

var request = new HTTPRequest(new Uri("http://server.com"), HTTPMethods.Post, onFinished);

request.SetHeader("Content-Type", "application/json; charset=UTF-8");
request.RawData = UTF8.Encoding.GetBytes(json);

request.Send();
```

## Display download progress

```language-csharp
var request = new HTTPRequest(new Uri("http://serveroflargefile.net/path"), (req, resp) => {
  Debug.Log("Finished!");
});

request.OnDownloadProgress += (req, down, length) => Debug.Log(string.Format("Progress: {0:P2}", down / (float)length));

request.Send();
```

## Abort a request

```language-csharp
var request = new HTTPRequest(new Uri(address), (req, resp) => {
	// State should be HTTPRequestStates.Aborted if we call Abort() before
	// it’s finishes
	Debug.Log(req.State);
});

request.Send();

// and then call Abort when the request isn't relevant anymore
request.Abort();
```

## Verify hostnames in HTTPS

```language-csharp
public sealed class HostNameVerifier : Org.BouncyCastle.Crypto.Tls.ICertificateVerifyer
{
    public bool IsValid(Uri targetUri, SecureProtocol.Org.BouncyCastle.Asn1.X509.X509CertificateStructure[] certs)
    {
        foreach (var cert in certs)
        {
            var values = cert.Subject.GetValueList();
            if (values.Contains(targetUri.Host))
                return true;
        }
 
        return false;
    }
}

HTTPManager.DefaultCertificateVerifyer = new HostNameVerifier();
```

## Get header values

```language-csharp
var request = new HTTPRequest(new Uri("https://httpbin.org/get"), (req, resp) =>
{
    // One response can contain multiple header: value pairs for the same 'header'.
    List<string> values = resp.GetHeaderValues("custom-header");
    foreach (string header in values)
        Debug.Log(header);

    // GetFirstHeaderValue returns the first header's value. It's good for headers that we are sure that occur only one per response.
    string contentLengthHeader = resp.GetFirstHeaderValue("content-length");
    Debug.Log(contentLengthHeader);
});

request.Send();
```