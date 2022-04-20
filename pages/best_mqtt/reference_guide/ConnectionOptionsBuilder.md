---
title: ConnectionOptionsBuilder
sidebar: best_mqtt_sidebar
---

## Description

Builder class to help creating [ConnectionOptions](ConnectionOptions.html) instances.

## Functions

- ### ConnectionOptionsBuilder WithTCP(string host, int port)

Set the `host` and `port` properties. It also sets the [ConnectionOptions](ConnectionOptions.html)' `Transport` property to `SupportedTransports.TCP`. Returns with the builder to be able to chain function calls together.

- ### ConnectionOptionsBuilder WithWebSocket(string host, int port)

Set the `host` and `port` properties. It also sets the [ConnectionOptions](ConnectionOptions.html)' `Transport` property to `SupportedTransports.WebSocket`. Returns with the builder to be able to chain function calls together.

- ### ConnectionOptionsBuilder WithTLS()

When used [MQTTClient](MQTTClient.html) going to use TLS to secure the communication. Returns with the builder to be able to chain function calls together.

- ### ConnectionOptionsBuilder WithPath(string path)

Used by the WebSocket transport to connect to the given path. Returns with the builder to be able to chain function calls together.

- ### ConnectionOptionsBuilder WithProtocolVersion(SupportedProtocolVersions version)

The protocol version that the plugin has to use to connect with to the server. Returns with the builder to be able to chain function calls together.

- ### MQTTClient CreateClient()

Creates an [MQTTClient](MQTTClient.html) object with the already set options.

- ### ConnectionOptions Build()

Returns with the final [ConnectionOptions](ConnectionOptions.html) instance.

## Examples

The following example creates a `ConnectionOptions` to connect to localhost on port 1883 using the TCP transport and MQTT protocol version v3.1.1.
```csharp
var options = new ConnectionOptionsBuilder()
        .WithTCP("localhost", 1883)        
        .WithProtocolVersion(SupportedProtocolVersions.MQTT_3_1_1)
        .Build();
		
var client = new MQTTClient(options);
```

This is the same as the previous exmaple, but creates the [MQTTClient](MQTTClient.html) :
```csharp
var client = new ConnectionOptionsBuilder()
        .WithTCP("localhost", 1883)        
        .WithProtocolVersion(SupportedProtocolVersions.MQTT_3_1_1)
        .CreateClient();
```