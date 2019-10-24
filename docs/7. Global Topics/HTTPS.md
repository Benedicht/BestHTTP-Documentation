# HTTPS

To support modern TLS/SSL version on as much platforms as the plugin just can, it comes bundled with [Bouncy Castle](https://github.com/bcgit/bc-csharp/). Bouncy Castle is the default TLS/SSL provider, and while it's a good replacement in general, sometime it can fail too for newer algorithms. Because of this, it's use can be disabled and the default `SslStream` implementation will be used.

To disable the use of Bouncy Castle globally, the following line can be added somewhere in a startup code:

```language-csharp
BestHTTP.HTTPManager.UseAlternateSSLDefaultValue = false;
```