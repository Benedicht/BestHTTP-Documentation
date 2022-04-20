---
title: ApplicationMessage
sidebar: best_mqtt_sidebar
---

## Description

An application message received from the broker.

## Properties

Additional details can be found in the [ApplicationMessagePacketBuilder documentation](../packet_builders/ApplicationMessagePacketBuilder.html).

- ### bool IsDuplicate
`true` if it's not the first ocassion the broker sent this application message. An application message can duplicated if it has been sent with a QoS level greater than 0 and and it's not the first time the broker tries to deliver it.

- ### QoSLevels QoS
[QoS level](../../getting_started/qos.html) this application message sent with.

- ### bool Retain
`true` if this is a [retained](../packet_builders/ApplicationMessagePacketBuilder.html#withretainbool-retain--true) application message.

- ### string Topic
The topic's name this application message is publish to.

- ### PayloadTypes PayloadFormat
Payload type (binary or text).

- ### TimeSpan ExpiryInterval
Expiry interval of the application message. If this is a retained application message `ExpiryInterval` this value is the original value the application message is sent with minus the time the message has been waiting on the broker.

- ### string ResponseTopic
Topic name where the publisher waiting for a response to this application message.

- ### BufferSegment CorrelationData
Arbitrary data sent with the application message. When a new message is published to the `ResponseTopic` as a response to this message, this `CollectionData` should be sent too.

- ### List<KeyValuePair<string, string>> UserProperties
Arbitrary key-value pairs sent with the application message.

- ### string ContentType
Arbitrary content type set by the publisher.

- ### BufferSegment Payload
Payload of the application message. 

{% include warning.html content="The memory region is reused after the callback is dispatched. The payload must be used or copied in the dispatching callback!" %}

## Examples

Receive and use textual payload:
```csharp
client.CreateSubscriptionBuilder("best_mqtt/test_topic")
        .WithMessageCallback(OnMessage)
        .WithMaximumQoS(QoSLevels.ExactlyOnceDelivery)
        .BeginSubscribe();
		
void OnMessage(MQTTClient client, SubscriptionTopic topic, string topicName, ApplicationMessage message)
{
    // Convert the raw payload to a string
    var text_payload = System.Text.Encoding.UTF8.GetString(message.Payload.Data, message.Payload.Offset, message.Payload.Count);

    // Print out the Content-Type value and the text payload
    Debug.Log($"Content-Type: '{message.ContentType}' Payload: '{text_payload}'");
}
```