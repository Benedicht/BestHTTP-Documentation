---
title: Supported Platforms
sidebar: best_mqtt_sidebar
---

## Supported Platforms

- **iOS**

	- No platform specific bugs or limitations are known.

- **Android**

	- To enable stripping link_android_subset.xml in the \Assets\Best HTTP\ folder should be used by renaming to link.xml.

- **Universal Windows Platform**

	- The native https handler can’t connect to custom ports. If you want to connect to a custom port using https you have to use the plugin’s alternate https handler by setting the request’s UseAlternateSSL to true.

- **WebGL**

	- In WebGL builds the plugin will use the underlying browser’s `XmlHTTPRequest` implementation. Because of this, there are features that isn’t available:
	
		- Cookies has limited support
		- Caching
		- Download and upload streaming doesn't work as `XmlHTTPRequest` buffers all data
		- Proxy
		- Server Certificate Validation
		- Redirection Control

		These limitations may change in a future update of the plugin.

	- If you make requests to another server that your WebGL build is loaded from the remote server must set some headers to enable the requests. For more details you can start reading on the Wikipedia page of [CORS](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing).

## Other limitations

- **HTTPS**

	On Android, iOS and desktop platforms .net’s Net SslStream are used for HTTPS. This can handle a wide range of certificates, however there are some that can fail with.
	To give an alternate solution [BouncyCastle](https://github.com/bcgit/bc-csharp) are bundled in the plugin, you can use it by setting the UseAlternateSSL to true on your HTTPRequest object. But it can fail on some certifications too.
	On Windows Phone 8.1(and greater) and on WinRT(Windows Store Apps) a secure, Tls 1.2 protocol will handle the connection.

- **HTTP/2**

	- Retry mechanism isn't implemented