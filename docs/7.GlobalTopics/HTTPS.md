# HTTPS

To support modern TLS/SSL version on as much platforms as the plugin just can, it comes bundled with [Bouncy Castle](https://github.com/bcgit/bc-csharp/). Bouncy Castle is the default TLS/SSL provider, and while it's a good replacement in general, sometime it can fail too for newer algorithms. Because of this, its usage can be disabled and the default `SslStream` implementation will be used instead.

To disable the use of Bouncy Castle globally, the following line can be added somewhere in a startup code:

```language-csharp
BestHTTP.HTTPManager.UseAlternateSSLDefaultValue = false;
```

`HTTPRequest` also has an `UseAlternateSSL` property, but because of connection pooling, the first request's value determines what TLS/SSL handler will be used. 


!!! Notice
	[HTTP/2](HTTP2.md) (because it depends on TLS' `ALPN` feature) and `Server Name Indication` works only with Bouncy Castle.
	
Other HTTPS related topcis are [Server Certificate Validation](../1.HTTP/AdvancedTopics/ServerCertificateValidation.md) and [Hostname verification](../1.HTTP/AdvancedTopics/SmallCode-Samples.md#verify-hostnames-in-https).

## How to debug HTTPS requests

The plugin doesn't verify server certificate so it's easy to set up a proxy and route the intersting requests through it. [Charles Proxy](https://www.charlesproxy.com) is one of the easiest proxy to set up and use.

The plugin also supports the [NSS Key Log Format](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/Key_Log_Format). In the editor when the *SSLKEYLOGFILE* environment variable is present, the plugin will write the *client random* of the SSL session to the file. 3rd party programs like [Wireshark](https://wiki.wireshark.org/TLS) can use this file to decrypt packets sent by the plugin.

## Certication Verification

The plugin by default doesn't do any certication verification, accepts all -including self signed- certificates. To add a global verifier `HTTPManager.DefaultCertificateVerifyer` can be used:

```language-csharp
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

HTTPManager.DefaultCertificateVerifyer = new CustomVerifier();
```

This implementation is the same as the one that the plugin uses by default: returns true for all https connection.