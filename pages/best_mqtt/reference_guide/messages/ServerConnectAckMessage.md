---
title: ServerConnectAckMessage
sidebar: best_mqtt_sidebar
---

## Description

## Properties

- ### bool SessionPresent
`true` if the broker had a saved [session](../../getting_started/sessions.html) for the sent [client ID](../packet_builders/ConnectPacketBuilder.html).

- ### ConnectAckReasonCodes ReasonCode
Any code other than Success is treated as an error and the client disconnects from the broker.

| Reason Code name | Description |
---|---
Success | The Connection is accepted.
Unspecified error | The Server does not wish to reveal the reason for the failure, or none of the other Reason Codes apply.
Malformed Packet | Data within the CONNECT packet could not be correctly parsed.
Protocol Error | Data in the CONNECT packet does not conform to this specification.
Implementation specific error | The CONNECT is valid but is not accepted by this Server.
Unsupported Protocol Version | The Server does not support the version of the MQTT protocol requested by the Client.
Client Identifier not valid | The Client Identifier is a valid string but is not allowed by the Server.
Bad User Name or Password | The Server does not accept the User Name or Password specified by the Client
Not authorized |	The Client is not authorized to connect.
Server unavailable | The MQTT Server is not available.
Server busy | The Server is busy. Try again later.
Banned | This Client has been banned by administrative action. Contact the server administrator.
Bad authentication method | The authentication method is not supported or does not match the authentication method currently in use.
Topic Name invalid | The Will Topic Name is not malformed, but is not accepted by this Server.
Packet too large | The CONNECT packet exceeded the maximum permissible size.
Quota exceeded | An implementation or administrative imposed limit has been exceeded.
Payload format invalid | The Will Payload does not match the specified Payload Format Indicator.
Retain not supported | The Server does not support retained messages, and Will Retain was set to 1.
QoS not supported | The Server does not support the QoS set in Will QoS.
Use another server | The Client should temporarily use another server.
Server moved | The Client should permanently use another server.
Connection rate exceeded | The connection rate limit has been exceeded.

- ### string ReasonString
The broker might send additional details why it sent the `ReasonCode`.

- ### UInt32? SessionExpiryInterval
If present it contains the `SessionExpiryInterval` used by the broker, otherwise the interval sent with the [connect packet](../packet_builders/ConnectPacketBuilder.html) is used.

- ### UInt16 ReceiveMaximum
The Server uses this value to limit the number of QoS 1 and QoS 2 publications that it is willing to process concurrently for the client. It does not provide a mechanism to limit the QoS 0 publications that the client might try to send. If the `Receive Maximum` value is absent, then its value defaults to 65,535.

- ### QoSLevels MaximumQoS
The maximum QoS level supported by the broker.

- ### bool RetainAvailable
`true` if retain is available for [application messages](../packet_builders/ApplicationMessagePacketBuilder.html#withretainbool-retain--true)

- ### UInt32 MaximumPacketSize
Maximum Packet Size the broker is willing to accept.

- ### string AssignedClientIdentifier
If the client sent a connect packet with a [null session](../../getting_started/sessions.html#null-sessions) this property contains the server assigned one. The plugin uses this value automatically to create a new session.

- ### UInt16 TopicAliasMaximum
The maximum number of topic aliases supported by the broker. See [MQTTClient's AddTopicAlias](../MQTTClient.html#void-addtopicaliasstring-topicname) function.

- ### List<KeyValuePair<string, string>> UserProperties
This property can be used by the broker to provide additional information to the client, including diagnostic information.

- ### bool WildcardSubscriptionAvailable
`false` if [wildcard subscriptions](../../getting_started/topic_filters.html) are **not** supported by the server.

- ### UInt16? ServerKeepAlive
The keep alive time assigned by the broker. If not present(it's `null`) the client will use its own keep alive time to send out ping requests to the broker.

- ### string ResponseInformation

> A UTF-8 Encoded String which is used as the basis for creating a Response Topic. The way in which the Client creates a Response Topic from the Response Information is not defined by this specification. 

> A common use of this is to pass a globally unique portion of the topic tree which is reserved for this Client for at least the lifetime of its Session. This often cannot just be a random name as both the requesting Client and the responding Client need to be authorized to use it. It is normal to use this as the root of a topic tree for a particular Client. For the Server to return this information, it normally needs to be correctly configured. Using this mechanism allows this configuration to be done once in the Server rather than in each Client.

- ### string ServerReference
A UTF-8 Encoded String which can be used by the broker to identify another broker to use. The broker uses a Server Reference in either a CONNACK or DISCONNECT packet with Reason code of 0x9C (Use another server) or Reason Code 0x9D (Server moved).

- ### string AuthenticationMethod
A UTF-8 Encoded String containing the name of the authentication method.

- ### BestHTTP.PlatformSupport.Memory.BufferSegment AuthenticationData
Binary Data containing authentication data. The contents of this data are defined by the authentication method and the state of already exchanged authentication data.

## Examples

Use the `TopicAliasMaximum` property to add [topic aliases](../MQTTClient.html#void-addtopicaliasstring-topicname).
```csharp
client = new MQTTClient(options);
client.OnServerConnectAckMessage += OnConnectAckCallback;

private static string[] LongTopicNames = new string[] {
    "Long Topic Name 1",
    "Long Topic Name 2",
    "Long Topic Name 3",
    // ...
    "Long Topic Name N"
};

private void OnConnectAckCallback(MQTTClient client, ServerConnectAckMessage connectAck)
{
    Debug.Log($"OnConnectAckCallback {connectAck.ReasonCode}");

    if (connectAck.ReasonCode == ConnectAckReasonCodes.Success)
    {
        var maxTopicAliases = Math.Min(LongTopicNames.Length, connectAck.TopicAliasMaximum);
        for (int i = 0; i < maxTopicAliases; i++)
            client.AddTopicAlias(LongTopicNames[i]);
   }
}
```