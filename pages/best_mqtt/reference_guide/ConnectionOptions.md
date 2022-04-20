---
title: ConnectionOptions
sidebar: best_mqtt_sidebar
---

## Description

Data class to hold all connection related options.

## Properties

- `string` **Host**: Host name or IP address of the broker.
- `int` **Port**: Port number where the broker is listening on.
- `bool` **UseTLS**: Whether to use a secure protocol (TLS).
- `SupportedTransports` **Transport**: Selected transport to connect with. It can be `SupportedTransports.TCP` or `SupportedTransports.WebSocket`. Its default value is `SupportedTransports.TCP`.
- `string` **Path**: Optional path for websocket, its default is `"/mqtt"`.
- `SupportedProtocolVersions` **ProtocolVersion**: The protocol version that the plugin has to use to connect with to the server. It can be `SupportedProtocolVersions.MQTT_3_1_1` or `SupportedProtocolVersions.MQTT_5_0`. Its default value is `SupportedProtocolVersions.MQTT_5_0`.

## Examples

The following example creates a `ConnectionOptions` to connect to localhost on port 1883 using the TCP transport and MQTT protocol version v3.1.1.

```csharp
ConnectionOptions options = new ConnectionOptions {
    Host = "localhost",
    Port = 1883,
    ProtocolVersion = SupportedProtocolVersions.MQTT_3_1_1
};

var client = new MQTTClient(options);
```