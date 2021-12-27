---
title: Server Certificate Validation
sidebar: best_http2_main_sidebar
---

Server sent certificates can be validated by implementing an `ICertificateVerifyer` interface and setting it to a HTTPRequest’s `CustomCertificateVerifyer`:

```csharp
using System;
using BestHTTP.SecureProtocol.Org.BouncyCastle.Crypto.Tls;
using BestHTTP.SecureProtocol.Org.BouncyCastle.Asn1.X509;

class CustomVerifier : ICertificateVerifyer
{
	public bool IsValid(Uri serverUri, X509CertificateStructure[] certs)
	{
		// TODO: Return false, if validation fails
   		return true;
	}
}

var request = new HTTPRequest(new Uri("https://google.com"), ...);
request.CustomCertificateVerifyer = new CustomVerifier();
request.UseAlternateSSL = true;
request.Send();
```
