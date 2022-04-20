---
title: BulkUnsubscribePacketBuilder
sidebar: best_mqtt_sidebar
---

## Description

Using this builder it's possible to unsubscribe from multiple topics using only one packet.

## Functions

- ### WithUserProperty(string key, string value)

A key-value pair can be added to the packet.

- ### WithTopicFilter(UnsubscribeTopicFilterBuilder topic)

An `UnsubscribeTopicFilterBuilder` represents a topic to unsubscribe from.

- ### BeginUnsubscribe()

By calling `BeginUnsubscribe()` the packet will be built and the plugin starts to send it to the broker.

## UnsubscribeTopicFilterBuilder

An `UnsubscribeTopicFilterBuilder` represents a topic to unsubscribe from.

### Constructor

- #### UnsubscribeTopicFilterBuilder(string filter)

The filter must be the very same filter that the client originally used in its subscription request.

### Functions

- #### WithAcknowledgementCallback(UnSubscribeAcknowledgementDelegate acknowledgementCallback)

A callback can be added that will be called when the server acknowledges the unscubscription. Any other reason code than `Success` is an error and means that unsubscribing from the topic failed.

```csharp
void UnSubscribeAcknowledgement(MQTTClient client, string topicName, UnsubscribeAckReasonCodes reasonCode)
{
}
```

Possible reason codes:
* Success
* NoSubscriptionExisted
* UnspecifiedError
* ImplementationSpecificError
* NotAuthorized
* TopicFilterInvalid
* PacketIdentifierInUse

## Examples

```csharp
client.CreateBulkUnsubscribePacketBuilder()
    .WithTopicFilter(new UnsubscribeTopicFilterBuilder("$SYS/#")
                            .WithAcknowledgementCallback(UnSubscribeAcknowledgementCallback))
    .WithTopicFilter(new UnsubscribeTopicFilterBuilder("best_mqtt/test_topic")
                            .WithAcknowledgementCallback(UnSubscribeAcknowledgementCallback))
    .BeginUnsubscribe();

private void UnSubscribeAcknowledgementCallback(MQTTClient client, string topicName, UnsubscribeAckReasonCodes reasonCode)
{
    Debug.Log($"Unsubscribe request from {topicName} returned: {reasonCode}");
}
```