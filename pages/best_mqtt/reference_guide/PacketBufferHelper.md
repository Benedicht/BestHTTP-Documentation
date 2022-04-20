---
title: PacketBufferHelper
sidebar: best_mqtt_sidebar
---

## Description

Helper class to help safely use [MQTTClient](MQTTClient.html)'s `BeginPacketBuffer`-`EndPacketBuffer` pairs in a using. With `BeginPacketBuffer` and `EndPacketBuffer` Best MQTT can send less network packets to the broker.

## Examples

```csharp
using (new PacketBufferHelper(client))
{
    client.CreateUnsubscribePacketBuilder("/#")
        .BeginUnsubscribe();
            
    client.CreateBulkSubscriptionBuilder()
        .WithTopic(new SubscribeTopicBuilder("$SYS/#")
            .WithMaximumQoS(QoSLevels.ExactlyOnceDelivery)
            .WithMessageCallback(OnSysMessages)
            .WithAcknowledgementCallback(OnSysMessagesSubscribeAck))
        .WithTopic(new SubscribeTopicBuilder("/test/msgs")
            .WithMaximumQoS(QoSLevels.ExactlyOnceDelivery)
            .WithMessageCallback(OnTestMessages)
            .WithAcknowledgementCallback(OnTestMessagesSubscribeAck))
        .BeginSubscribe();
}
```

The same behavior using `BeginPacketBuffer`-`EndPacketBuffer` would be the following:

```csharp
client.BeginPacketBuffer();
try
{
    client.CreateUnsubscribePacketBuilder("/#")
        .BeginUnsubscribe();
            
    client.CreateBulkSubscriptionBuilder()
        .WithTopic(new SubscribeTopicBuilder("$SYS/#")
            .WithMaximumQoS(QoSLevels.ExactlyOnceDelivery)
            .WithMessageCallback(OnSysMessages)
            .WithAcknowledgementCallback(OnSysMessagesSubscribeAck))
        .WithTopic(new SubscribeTopicBuilder("/test/msgs")
            .WithMaximumQoS(QoSLevels.ExactlyOnceDelivery)
            .WithMessageCallback(OnTestMessages)
            .WithAcknowledgementCallback(OnTestMessagesSubscribeAck))
        .BeginSubscribe();
}
finally
{
    client.EndPacketBuffer();
}
```