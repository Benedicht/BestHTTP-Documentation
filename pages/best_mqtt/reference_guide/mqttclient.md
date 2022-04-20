---
title: MQTTClient
sidebar: best_mqtt_sidebar
---

## Description

## Events

For events and theirs description see the [MQTTClientBuilder](MQTTClientBuilder.html#functions)'s documentation.

## Properties

- [ConnectionOptions](ConnectionOptions.html) `Options`: Connection related options.
- [ClientStates](MQTTClientBuilder.html#possible-states-of-an-mqttclient) `State`: Current state of the client. State changed events are emitted through the [OnStateChanged](MQTTClientBuilder.html#witheventhandleronstatechangeddelegate-onstatechanged) event.
- [NegotiatedOptions](NegotiatedOptions.html) `NegotiatedOptions`: Options negotiated with the broker.
- [Session](SessionHelper.html) `Session`: Session instance to persist QoS data.
- [LoggingContext](../../best_http2/global_topics/Logging.html#loggingcontext) `Context`: Context of the MQTTClient and all child instances (like its transport, etc.) that can produce log outputs.

## Functions

- ### void BeginPacketBuffer()
With the use of BeginPacketBuffer and EndPacketBuffer sent messages can be buffered and sent in less network packets. It supports nested Begin-EndPacketBuffer calls.

{% include tip.html content="Instead of using `BeginPacketBuffer()` and `EndPacketBuffer()` directly, use the [PacketBufferHelper](PacketBufferHelper.html) instead!" %}

- ### void EndPacketBuffer()
Call this after a BeginPacketBuffer.

{% include tip.html content="Instead of using `BeginPacketBuffer()` and `EndPacketBuffer()` directly, use the [PacketBufferHelper](PacketBufferHelper.html) instead!" %}

- ### BeginConnect(ConnectPacketBuilderDelegate connectPacketBuilderCallback, CancellationToken token = default)
Starts the connection process to the broker. It's a non-blocking method. ConnectPacketBuilderCallback is a function that will be called after a successfully transport connection to negotiate protocol details.

```csharp
// Connect without any customization.
client.BeginConnect((client, builder) => builder);
```

- ### Task<MQTTClient> ConnectAsync(ConnectPacketBuilderDelegate connectPacketBuilder, CancellationToken token = default)
Task-based, awaitable connect implementation. It has the same behavior as `BeginConnect`.

```csharp
try
{
    await client.ConnectAsync(ConnectPacketBuilderCallback);
}
catch (Exception ex)
{
    Debug.LogException(ex);
}

ConnectPacketBuilder ConnectPacketBuilderCallback(MQTTClient client, ConnectPacketBuilder builder) => builder;

```

- ### ConnectPacketBuilder CreateConnectPacketBuilder()
Creates and returns with a [ConnectPacketBuilder](packet_builders/ConnectPacketBuilder.html) instance. Normally it isn't used as the ConnectPacketBuilder callback passed to the `BeginConnect`/`ConnectAsync` calls already receiving a builder.

```csharp
private ConnectPacketBuilder ConnectPacketBuilderCallback(MQTTClient client, ConnectPacketBuilder builder)
{
    return client.CreateConnectPacketBuilder()
	               .WithUserNameAndPassword("<user>", "<passwd>");
}
```

- ### SubscribePacketBuilder CreateSubscriptionBuilder(string topicFilter)
Creates and returns with a [SubscribePacketBuilder](packet_builders/SubscribePacketBuilder.html). A `SubscribePacketBuilder` can be used to subscribe to a single topic.

```csharp
client.CreateSubscriptionBuilder("best_mqtt/test_topic")
        .WithMessageCallback(OnMessage)
        .BeginSubscribe();
```

- ### BulkSubscribePacketBuilder CreateBulkSubscriptionBuilder()
Creates and return with a [BulkSubscribePacketBuilder](packet_builders/BulkSubscribePacketBuilder.html) instance. A `BulkSubscribePacketBuilder` can be used to subscribe to multiple topics with less overhead than using multiple `SubscribePacketBuilder`s.

```csharp
client.CreateBulkSubscriptionBuilder()
        .WithTopic(new SubscribeTopicBuilder("$SYS/#").WithMessageCallback(OnSysMessages))
        .WithTopic(new SubscribeTopicBuilder("/test/msgs").WithMessageCallback(OnTestMessages))
        .BeginSubscribe();
```

- ### UnsubscribePacketBuilder CreateUnsubscribePacketBuilder(string topicFilter)
Creates and returns with an [UnsubscribePacketBuilder](packet_builders/UnsubscribePacketBuilder.html) instance. An `UnsubscribePacketBuilder` can be used to unsubscribe from a single topic.

```csharp
client.CreateUnsubscribePacketBuilder("best_mqtt/test_topic")
        .BeginUnsubscribe();
```

- ### BulkUnsubscribePacketBuilder CreateBulkUnsubscribePacketBuilder()
Creates and returns with a [BulkUnsubscribePacketBuilder](packet_builders/BulkUnsubscribePacketBuilder.html) instance. A `BulkUnsubscribePacketBuilder` can be used to unsubscribe from multiple topics with less overhead than using multiple `UnsubscribePacketBuilder`s.

```csharp
client.CreateBulkUnsubscribePacketBuilder()
         .WithTopicFilter(new UnsubscribeTopicFilterBuilder("topic 1"))
         .WithTopicFilter(new UnsubscribeTopicFilterBuilder("topic 2"))
         .BeginUnsubscribe();
```

- ### void AddTopicAlias(string topicName)

Frequnetly sent and/or long topic names can add significant overhead to all application messages. To reduce this overhead a topic alias can be added and the plugin can switch consecutive application messages' topic for a short id to send. The maximum number of topic alias supported by the server can be found through `NegotiatedOptions.ServerOptions.TopicAliasMaximum`.

```csharp
private static string[] LongTopicNames = new string[] {
    "Long Topic Name 1",
    "Long Topic Name 2",
    "Long Topic Name 3",
    // ...
    "Long Topic Name N"
};

void OnConnected(MQTTClient client)
{
    var maxTopicAliases = Math.Min(LongTopicNames.Length, client.NegotiatedOptions.ServerOptions.TopicAliasMaximum);
    for (int i = 0; i < maxTopicAliases; i++)
        client.AddTopicAlias(LongTopicNames[i]);
}
```

{% include warning.html content="Isn't available with MQTT v3.1.1" %}

- ### ApplicationMessagePacketBuilder CreateApplicationMessageBuilder(string topicName)
Creates and returns with an [ApplicationMessagePacketBuilder](packet_builders/ApplicationMessagePacketBuilder.html) instance. An `ApplicationMessagePacketBuilder` can be used to publish messages to a topic.

```csharp
client.CreateApplicationMessageBuilder("best_mqtt/test_topic")
        .WithPayload("Hello MQTT World!")
        .BeginPublish();
```

- ### AuthenticationPacketBuilder CreateAuthenticationPacketBuilder()
Creates and returns with an [AuthenticationPacketBuilder](packet_builders/AuthenticationPacketBuilder.html) instance. An `AuthenticationPacketBuilder` can be used to send additional authentication data when the broker requests it. For more details and usage of the builder read the topic about [Extended Authentication](../other/authentication.html#extended-authentication).

{% include warning.html content="Isn't available with MQTT v3.1.1" %}

- ### DisconnectPacketBuilder CreateDisconnectPacketBuilder()

Creates and returns with a [DisconnectPacketBuilder](packet_builders/DisconnectPacketBuilder.html) instance. A `DisconnectPacketBuilder` can be used to initiate a graceful disconnection from the broker.

```csharp
client.CreateDisconnectPacketBuilder()
            .BeginDisconnect();
```

## Examples