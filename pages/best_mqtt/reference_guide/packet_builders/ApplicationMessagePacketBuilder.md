---
title: ApplicationMessagePacketBuilder
sidebar: best_mqtt_sidebar
---

## Description

An `ApplicationMessagePacketBuilder` can be used to publish messages to a topic. The topic must be a concrete one, it **must not** contain [wildcards](../../getting_started/topic_filters.html). 

{% include note.html content="The default QoS setting for an Application Message is `QoSLevels.AtMostOnceDelivery` (QoS 0)." %}
{% include warning.html content="Allways call BeginPublish(), without it no application message is sent out to the broker!" %}

## Functions

- ### WithQoS(QoSLevels qos)
The application message will be published with the given [QoS level](../../getting_started/qos.html). If `WithQoS` isn't used, the application message is published with QoS 0.

```csharp
client.CreateApplicationMessageBuilder("best_mqtt/test_topic")
        .WithPayload("Hello MQTT World!")
        .WithQoS(QoSLevels.ExactlyOnceDelivery)
        .BeginPublish();
```

{% include note.html content="QoS level only guarantees delivery to the broker only, subscribers might have different QoS level settings! See [QoS Downgrade topic](../..//getting_started/qos.html#qos-downgrade)." %}

- ### WithRetain(bool retain = true)

Application messages flagged as retained are saved on the broker and sent to new subscribers to the topic until the application message expires. Application messages sent with QoS 0 (AtMostOnceDelivery) can be discarded any time by the broker. If this happens there will be no retained message for that topic.
Whether the broker supports retained messages is sent to the client in the [ServerConnectAckMessage](messages/ServerConnectAckMessage.html) and can be accessed through MQTTClient's `NegotiatedOptions.ServerOptions.RetainAvailable` field:
```csharp
void OnConnected(MQTTClient client)
{
    if (client.NegotiatedOptions.ServerOptions.RetainAvailable)
        Debug.Log("Broker supports retained application messages!");
    else
        Debug.Log("Retain isn't available!");
}
```

- ### WithPayloadFormatIndicator(PayloadTypes payloadType)

The server sends this data to all of its subscribers unaltered. Subscribers receiving this application message might use it to validate the payload.

Available options:
0. **PayloadTypes.Bytes**: Indicates that the Payload is unspecified bytes, which is equivalent to not setting a Payload Format Indicator.
1. **PayloadTypes.UTF8**: Indicates that the Payload is UTF-8 Encoded Character Data. The UTF-8 data in the Payload MUST be well-formed UTF-8 as defined by the [Unicode specification](http://www.unicode.org/versions/latest/) and restated in [RFC 3629](http://www.rfc-editor.org/info/rfc3629).

{% include warning.html content="Isn't available with MQTT v3.1.1" %}

- ### WithMessageExpiryInterval(UInt32 seconds)
Lifetime of the Application Message in seconds. If the Message Expiry Interval has passed and the broker has not managed to start onward delivery to a matching subscriber, then the application message is going to be removed from the subscriber's message queue. If an expire interval isn't set, the application message isn't expires!

{% include warning.html content="Isn't available with MQTT v3.1.1" %}

- ### WithResponseTopic(string responseTopic)
Can be used to inform subscribers where the client is listening for application messages sent as a response for this message. If there's any correlation data sent along with this message, the responder should include it unaltered.

{% include warning.html content="Isn't available with MQTT v3.1.1" %}

- ### WithCorrelationData(byte[] data)
The correlation data is used by the sender of the request message to identify which request the response message is for when it is received.

{% include warning.html content="Isn't available with MQTT v3.1.1" %}

- ### WithUserProperty(string key, string value)
Using this function an arbitrary key-value pair can be added to the application message. The meaning of the added key-value pair is up to the sender and receiver. The same `key` is allowed to appear more than once.

{% include warning.html content="Isn't available with MQTT v3.1.1" %}

- ### WithContentType(string contentType)
The MIME type of the payload can be added with this function. The value of the Content Type is defined by the sending and receiving application, the broker doesn't use this value.

{% include warning.html content="Isn't available with MQTT v3.1.1" %}

- ### WithPayload(byte[] payload)
Set the application message's payload.

- ### WithPayload(string payload)
Set the application message's payload. When MQTT v5 or newer is used, it also sets the payload format indicator to `PayloadTypes.UTF8`.

- ### BeginPublish()
Starts sending the application message to the broker.

## Examples

### Minimal example with text payload

```csharp
client.CreateApplicationMessageBuilder("topic/to/publish")
        .WithPayload("Text Payload")
        .BeginPublish();
```

### Send binary

```csharp
byte[] binary = new byte[0];
client.CreateApplicationMessageBuilder("topic/to/publish")
        .WithPayload(binary)
        .BeginPublish();
```

### Send compressed data

```csharp

byte[] compressed = GetAndCompressData();

client.CreateApplicationMessageBuilder("topic/to/publish")
    .WithContentType("application/gzip")
    .WithPayload(compressed)
    .BeginPublish();
```

### Send with QoSLevels.AtLeastOnceDelivery (QoS 1)

```csharp
client.CreateApplicationMessageBuilder("topic/to/publish")
        .WithQoS(QoSLevels.AtLeastOnceDelivery)
        .WithPayload("Payload")
        .BeginPublish();
```

### Send with QoSLevels.ExactlyOnceDelivery (QoS 2)

```csharp
client.CreateApplicationMessageBuilder("topic/to/publish")
        .WithQoS(QoSLevels.ExactlyOnceDelivery)
        .WithPayload("Payload")
        .BeginPublish();
```