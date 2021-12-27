---
title: Last-Will
sidebar: best_mqtt_sidebar
summary: A last will is a regular application message, but the client can set it up and send while connecting to the broker. The broker will distribute this last-will only when the client goes offline and the last-will's Delay Interval expires.
---

## Creating a Last-Will

A last-will can be created in the [connect packget builder callback](client_setup.html#connecting). The following code creates a last-will that will be published to the "client/last-will" topic 60 seconds after the client gone offline.

```csharp
private ConnectPacketBuilder ConnectPacketBuilderCallback(MQTTClient client, ConnectPacketBuilder builder)
{
    return builder.WithLastWill(new LastWillBuilder()
                                    .WithDelayInterval(60)
                                    .WithTopic("client/last-will")
                                    .WithQoS(QoSLevels.ExactlyOnceDelivery)
                                    .WithPayload("This is my last will!"));
}
```