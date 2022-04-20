---
title: UnsubscribePacketBuilder
sidebar: best_mqtt_sidebar
---

## Description

With the use of `UnsubscribePacketBuilder` it's possible to unsubscribe from a topic. An `UnsubscribePacketBuilder` can be created through MQTTClient's [CreateUnsubscribePacketBuilder](../MQTTClient.html#unsubscribepacketbuilder-createunsubscribepacketbuilderstring-topicfilter).

## Functions

- ### WithAcknowledgementCallback(UnSubscribeAcknowledgementDelegate acknowledgementCallback)

A callback can be added that will be called when the server acknowledges the unscubscription. Any other reason code than `Success` is an error and means that unsubscribing from the topic failed.

```csharp
void UnSubscribeAcknowledgementDelegate(MQTTClient client, string topicName, UnsubscribeAckReasonCodes reasonCode)
{
}
```

Possible reason code values:
* Success
* NoSubscriptionExisted
* UnspecifiedError
* ImplementationSpecificError
* NotAuthorized
* TopicFilterInvalid
* PacketIdentifierInUse

## Examples

```csharp
client.CreateUnsubscribePacketBuilder("best_mqtt/test_topic")
    .WithAcknowledgementCallback(UnSubscribeAcknowledgementCallback)
    .BeginUnsubscribe();
	
void UnSubscribeAcknowledgementCallback(MQTTClient client, string topicName, UnsubscribeAckReasonCodes reasonCode)
{
    Debug.Log($"Unsubscribe request from {topicName} returned: {reasonCode}");
}
```