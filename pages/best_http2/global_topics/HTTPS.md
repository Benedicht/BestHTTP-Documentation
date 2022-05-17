---
title: HTTPS
sidebar: best_http2_main_sidebar
---

## HTTPS

To support modern TLS versions on as much platforms as the plugin just can, it comes bundled with [Bouncy Castle](https://github.com/bcgit/bc-csharp/). Bouncy Castle is the default TLS provider of the plugin and while it's a good replacement in general, sometime it can fail too for newer algorithms. Because of this, its usage can be disabled and the default `SslStream` implementation will be used instead.

To disable the use of Bouncy Castle globally, the following line can be added somewhere in a startup code:

```csharp
BestHTTP.HTTPManager.UseAlternateSSLDefaultValue = false;
```

{% include note.html content="[HTTP/2](HTTP2.md) works only when Bouncy Castle is in use, because it depends on TLS' `ALPN` feature" %}

## Server Certication Verification

The plugin by default doesn't do any certication verification, accepts all -including self signed- certificates. To add a global verifier the default TLS client implementation can used as a base class:

```csharp
using BestHTTP.SecureProtocol.Org.BouncyCastle.Tls;

public sealed class CustomTlsClient : BestHTTP.Connections.TLS.DefaultTls13Client
{
    public CustomTlsClient(Uri uri, List<ServerName> sniServerNames, List<ProtocolName> protocols) : base(uri, sniServerNames, protocols)
    {
    }

    public override void NotifyServerCertificate(TlsServerCertificate serverCertificate)
    {
        // TODO: Verify the server sent certificate(s). Throw exceptions when invalid.
    }
}
```

And must be used in a TLS client factory:
```csharp
HTTPManager.TlsClientFactory = (HTTPRequest request, List<ProtocolName> protocols) =>
{
    List<ServerName> hostNames = null;

    // If there's no user defined one and the host isn't an IP address, add the default one
    if (!request.CurrentUri.IsHostIsAnIPAddress())
    {
        hostNames = new List<ServerName>(1);
        hostNames.Add(new ServerName(0, System.Text.Encoding.UTF8.GetBytes(request.CurrentUri.Host)));
    }

    return new CustomTlsClient(request.CurrentUri, hostNames, protocols);
};
```

This implementation is the same as the one that the plugin uses by default: accepts all certificates. I would recommend to use the [TLS Security Addon](https://assetstore.unity.com/packages/tools/network/best-http-2-tls-security-addon-184441?aid=1101lfX8E) for a full-fledged solution.

## Client Certications

Similarly to the server certication verification, the `GetClientCredentials` function can be overridden in the custom tls client to load and return with the client's certication:

```csharp
public sealed class CustomTlsClient : BestHTTP.Connections.TLS.DefaultTls13Client
{
    public CustomTlsClient(Uri uri, List<ServerName> sniServerNames, List<ProtocolName> protocols) : base(uri, sniServerNames, protocols)
    {
    }

    public override TlsCredentials GetClientCredentials(CertificateRequest certificateRequest)
    {
        // TODO: find and return with a client certificate. base._uri contains the original uri the plugin trying to connect to.
        return null;
    }
}
```

To manage client certificates, i would recommend to use the [TLS Security Addon](https://assetstore.unity.com/packages/tools/network/best-http-2-tls-security-addon-184441?aid=1101lfX8E) for a full-fledged solution.

## How to debug HTTPS requests

The plugin doesn't verify server certificate so it's easy to set up a proxy and route the intersting requests through it. [Charles Proxy](https://www.charlesproxy.com) is one of the easiest proxy to set up and use.

The plugin also supports the [NSS Key Log Format](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/Key_Log_Format). In the editor when the *SSLKEYLOGFILE* environment variable is present, the plugin will write the *client random* of the SSL session to the file. 3rd party programs like [Wireshark](https://wiki.wireshark.org/TLS) can use this file to decrypt packets sent by the plugin.

## How to enable TLS 1.1

v2.6.0 upped the minimum supported TLS version to 1.2, but support for 1.1 still can be enabled the following way:

```csharp
using BestHTTP;
using BestHTTP.Extensions;
using BestHTTP.SecureProtocol.Org.BouncyCastle.Tls;

// Place this line somewhere in your startup code
HTTPManager.TlsClientFactory = Tls11ClientFactory;

// TLS client factory implementation
public static BestHTTP.Connections.TLS.AbstractTls13Client Tls11ClientFactory(HTTPRequest request, List<ProtocolName> protocols)
{
    List<ServerName> hostNames = null;

    if (!request.CurrentUri.IsHostIsAnIPAddress())
    {
        hostNames = new List<ServerName>(1);
        hostNames.Add(new ServerName(0, System.Text.Encoding.UTF8.GetBytes(request.CurrentUri.Host)));
    }

    return new SupportForTLS11TlsClient(request, hostNames, protocols);
}

// Override the default tls client implemetation to add support for Tls v1.1
class SupportForTLS11TlsClient : BestHTTP.Connections.TLS.DefaultTls13Client
{
    public SupportForTLS11TlsClient(HTTPRequest request, List<ServerName> sniServerNames, List<ProtocolName> protocols)
            : base(request, sniServerNames, protocols)
    {
    }

    protected override ProtocolVersion[] GetSupportedVersions() => ProtocolVersion.TLSv13.DownTo(ProtocolVersion.TLSv11);
}
```