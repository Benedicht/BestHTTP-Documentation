---
title: Optimization Tips & Tricks
sidebar: best_mqtt_sidebar
summary: Collection of tips and tricks to optmize various aspects of the plugin.
---

## Wrap multiple calls with `PacketBufferHelper`

Using `PacketBufferHelper` we can buffer up MQTT packets and send them in fewer network packets:

```csharp
private void OnConnected(MQTTClient client)
{
    using (new PacketBufferHelper(client))
    {
        client.AddTopicAlias("best_mqtt/test_topic");

        client.CreateSubscriptionBuilder("best_mqtt/test_topic")
                .WithMessageCallback(OnMessage)
                .BeginSubscribe();

        client.CreateApplicationMessageBuilder("best_mqtt/test_topic")
                .WithPayload("Hello MQTT World!")
                .WithQoS(BestMQTT.Packets.QoSLevels.ExactlyOnceDelivery)
                .WithContentType("text/plain; charset=UTF-8")
                .BeginPublish();
    }
}
```

## Use Topic Aliases

To spare sending the topic name every time with an application message a topic alias can be added. It's recommended to use it for long or frequantly used topic names.
```csharp
private void OnConnected(MQTTClient client)
{
    client.AddTopicAlias("best_mqtt/test_topic");
}
```

`AddTopicAlias` doesn't generate a packet, the mapping is sent with the next application message that going to be sent with that topic name.

## Compress text payloads

Large text payloads should be sent compressed when possible. Using the `WithContentType` the publisher can indicate that the payload is compressed and subscribers can act accordingly.