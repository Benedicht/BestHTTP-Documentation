---
title: Introduction
sidebar: best_http2_main_sidebar
---

## SignalR Core

The new [SignalR Core](https://docs.microsoft.com/en-us/aspnet/core/signalr/introduction?view=aspnetcore-3.0) protocol is a new iteration for the SignalR family. It tries to keep and improve what worked and remove the bad, but this also means that it's not backward compatible.

The plugin's SignalR Core implements two transports: Long-Polling and WebSockets. First it will try to connect with the prefered transort set in the HubOptions (the default value is the Websockets transport), and when connecting with the transport fails, it will try the next available (Long-Polling).

To continue with SignalR Core read about the [HubConnection](HubConnection.html) class.