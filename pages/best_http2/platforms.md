---
title: Supprted Platforms
sidebar: best_http2_main_sidebar
---

## Supported platforms and their limitations

- **Desktop (Windows, Linux, MacOS)**

	- No platform specific bugs or limitations are known.
	
- **iOS**

	- No platform specific bugs or limitations are known.

- **Android**

	- The [Android Proxy Detector](global_topics/Proxy.html#automatic-proxy-detection) requires the [Android JNI module](https://docs.unity3d.com/ScriptReference/UnityEngine.AndroidJNIModule.html). It can be enablad through the [Package Manager window](https://docs.unity3d.com/Manual/upm-ui.html).
	- To enable stripping link_android_subset.xml in the \Assets\Best HTTP\ folder should be used by renaming to link.xml.

- **Universal Windows Platform**

	- The native https handler can’t connect to custom ports. If you want to connect to a custom port using https you have to use the plugin’s alternate https handler by setting the request’s UseAlternateSSL to true.

- **WebGL**

	- In WebGL builds the plugin will use the underlying browser’s `XmlHTTPRequest` implementation for HTTP, `WebSocket` for WebSocket and `EventSource` for Server-Sent Events. Because of this, there are features that isn’t available:
	
		- Cookies has limited support (They are managed by the underlying browser.)
		- Caching (Managed by the underlying browser.)
		- Download and upload streaming doesn't work as `XmlHTTPRequest` buffers all data
		- Proxy (Managed by the underlying browser.)
		- Server Certificate Validation (Managed by the underlying browser.)
		- Redirection Control
		- No custom headers for WebSocket (See [WHATWG ISSUE#16](https://github.com/whatwg/websockets/issues/16)!)

	- If you make requests to another server that your WebGL build is loaded from the remote server must set some headers to enable the requests. For more details you can start reading on the Wikipedia page of [CORS](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing).