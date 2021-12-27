---
title: Thread Safety
sidebar: best_http2_main_sidebar
---

## Thread Safety
Because the plugin internally uses threads to process all requests parallelly, all shared resources(cache, cookies, etc) are designed and implemented with thread safety in mind.
By deafult, calling the requests’ callback functions, and all other callbacks (like the WebSocket’s callbacks) are made on Unity’s main thread(like Unity’s events: awake, start, update, etc) so you don’t have to do any thread synchronization.

Creating, sending requests on more than one thread are safe too, but you should call the `BestHTTP.HTTPManager.Setup()`; function before sending any request from one of Unity’s events (eg. awake, start).
