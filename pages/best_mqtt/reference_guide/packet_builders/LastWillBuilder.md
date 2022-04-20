---
title: LastWillBuilder
sidebar: best_mqtt_sidebar
---

## Description

A builder to build [last-will messages](../../getting_started/last_will.html).

## Functions

`LastWillBuilder`'s functions is a subset of the [ApplicationMessagePacketBuilder](ApplicationMessagePacketBuilder.html).

## Examples

```csharp
ConnectPacketBuilder ConnectPacketBuilderCallback(MQTTClient client, ConnectPacketBuilder builder)
{
    var lastWillBuilder = new LastWillBuilder()
        .WithTopic("best_mqtt/test_topic")
        .WithPayload("Will message!")
        .WithDelayInterval(5) // wait 5 seconds before publishing the will message
        .WithQoS(QoSLevels.ExactlyOnceDelivery);

    return builder
        .WithLastWill(lastWillBuilder);
}
```