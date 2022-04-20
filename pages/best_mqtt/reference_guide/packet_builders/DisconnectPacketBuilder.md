---
title: DisconnectPacketBuilder
sidebar: best_mqtt_sidebar
---

## Description

A `DisconnectPacketBuilder` must be created through `MQTTClient`'s [CreateDisconnectPacketBuilder](../MQTTClient.html#disconnectpacketbuilder-createdisconnectpacketbuilder).

## Functions

- ### WithReasonCode(DisconnectReasonCodes reasonCode)

A reason code can be added using this function. When not used, the plugin will send a `NormalDisconnection` error code.

- ### WithReasonString(string reason)

An additional reason string can added for debugging purposes.

- ### WithSessionExpiryInterval(UInt32 seconds)

If the Session Expiry Interval is absent, the Session Expiry Interval in the [CONNECT packet](ConnectPacketBuilder.html) is used.

- ### WithUserProperty(string key, string value)

A key-value pair can be added to the packet.

## Examples

```csharp
client.CreateDisconnectPacketBuilder()
        .BeginDisconnect();
```