---
title: BulkSubscribePacketBuilder
sidebar: best_mqtt_sidebar
---

## Description

With a bulk subscribe packet builder it's possible to subscribe to more than one topic using only one packet. Its behavior is the very same as using more [subscribe packet builders](SubscribePacketBuilder.html).
A `SubscribePacketBuilder` must be acquired through the MQTTClient's [CreateSubscriptionBuilder](../MQTTClient.html#bulksubscribepacketbuilder-createbulksubscriptionbuilder).

## Functions

- ### WithTopic([SubscribeTopicBuilder](#SubscribeTopicBuilder) topicBuilder)
With this function a [new topic](../../getting_started/topic_filters.html) can be added to the builder to subscribe to. It can be called more than once.

- #### WithUserProperty(string key, string value)
A key-value pair can be added to the packet.

- ### BeginSubscribe()
By calling `BeginSubscribe()` the packet will be built and the plugin starts to send it to the broker.
___

## SubscribeTopicBuilder

### Constructor

- #### SubscribeTopicBuilder(string topicFilter)
A new SubscribeTopicBuilder must be created through its constructor that accepts a topic filter string. The topic filter can be a concrete topic name or a topic filter. See [Topic Names & Filters](../../getting_started/topic_filters.html).

### Functions

- #### WithMaximumQoS(QoSLevels maxQoS)
The maximum [QoS level](../../getting_started/qos.html) the client want to support. If maximum QoS isn't set, QoS 0 will be sent.

- #### WithNoLocal()
If called, the broker will not forward application messages sent by this client.

{% include warning.html content="Isn't available with MQTT v3.1.1" %}

- #### WithRetainAsPublished()
Application messages forwarded using this subscription keep the RETAIN flag they were published with.

{% include warning.html content="Isn't available with MQTT v3.1.1" %}

- #### WithRetainHandlingOptions(RetaionHandlingOptions options)

Option | Description
---|---
SendWhenSubscribe | Send retained messages at the time of the subscribe.
SendWhenSubscribeIfSubscriptionDoesntExist | Send retained messages at subscribe only if the subscription does not currently exist.
DoNotSendRetainedMessages | Do not send retained messages at the time of the subscribe

{% include warning.html content="Isn't available with MQTT v3.1.1" %}

- #### WithAcknowledgementCallback(SubscriptionAcknowledgementDelegate callback)

An acknowledgement callback must look like the following:
```csharp
void SubscriptionAcknowledgement(MQTTClient client, SubscriptionTopic topic, SubscribeAckReasonCodes reasonCode)
{
}
```

Possible reason code values:
* GrantedQoS0
* GrantedQoS1
* GrantedQoS2
* UnspecifiedError
* ImplementationSpecificError
* NotAuthorized
* TopicFilterInvalid
* PacketIdentifierInUse
* QuotaExceeded
* SharedSubscriptionsNotSupported
* SubscriptionIdentifiersNotSupported
* WildcardSubscriptionsNotSupported

`GrantedQoS0`, `GrantedQoS1` and `GrantedQoS2` returned when the subscription is successful. The server might grant a lower QoS level than requested!
Any reason code other then these three are error codes and the subscription request is declined.

- #### WithMessageCallback(SubscriptionMessageDelegate callback)

A callback can be added for [application messages](../messages/ApplicationMessage.html) sent to this subscription.

```csharp
void SubscriptionMessageDelegate(MQTTClient client, SubscriptionTopic topic, string topicName, ApplicationMessage message)
{
}
```

## Examples

```csharp
client.CreateBulkSubscriptionBuilder()
    // First topic
    .WithTopic(new SubscribeTopicBuilder("$SYS/#")
        .WithMaximumQoS(QoSLevels.ExactlyOnceDelivery)
        .WithMessageCallback(OnApplicationMessage)
        .WithAcknowledgementCallback(OnSubscriptionAck))
    // Second topic
    .WithTopic(new SubscribeTopicBuilder("/test/msgs")
        .WithMaximumQoS(QoSLevels.ExactlyOnceDelivery)
        .WithMessageCallback(OnApplicationMessage)
        .WithAcknowledgementCallback(OnSubscriptionAck))
    // Send it to the broker
    .BeginSubscribe();
	
private void OnSubscriptionAck(MQTTClient client, SubscriptionTopic topic, SubscribeAckReasonCodes reasonCode)
{
    Debug.Log($"Subscription to topic '{topic.Filter.OriginalFilter}' returned: {reasonCode}");
}

private void OnApplicationMessage(MQTTClient client, SubscriptionTopic topic, string topicName, ApplicationMessage message)
{
    string text_payload = System.Text.Encoding.UTF8.GetString(message.Payload.Data, message.Payload.Offset, message.Payload.Count);
    Debug.Log($"[{topic}]({topicName}): '{text_payload}'");
}
```