---
title: MQTTClientBuilder
sidebar: best_mqtt_sidebar
---

## Description

Builder class to help creating [MQTTClient](MQTTClient.html) instances.

## Functions

All functions except `CreateClient` returns with the `MQTTClientBuilder` instance to be able to chain function calls together.

- ### WithOptions(ConnectionOptions options)

The [MQTTClient](MQTTClient.html) going to use the options passed to this function.

- ### WithOptions(ConnectionOptionsBuilder builder)

The [MQTTClient](MQTTClient.html) going to use the options built by the builder passed to this function.

- ### WithEventHandler(OnConnectedDelegate onConnected)

The [MQTTClient](MQTTClient.html) going to be created with this `OnConnected` event handler. The `OnConnected` event is called when the client succesfully connects with its transport to the broker and the protocol negotiation completes. 
```csharp
private void OnConnected(MQTTClient client)
{
    // ...
}
```

- ### WithEventHandler(OnServerConnectAckMessageDelegate onServerConnectAckMessage)

The [MQTTClient](MQTTClient.html) going to be created with this `OnServerConnectAckMessage` event handler. The `OnServerConnectAckMessage` event is called when the client receives the response for its connect packet (see [MQTTClient](MQTTClient.html)'s `BeginConnect`). 

```csharp
private void OnServerConnectAckMessage(MQTTClient client, ServerConnectAckMessage message)
{
    // ...
}
```

{% include note.html content="`OnServerConnectAckMessage` is called no matter how the connection negotiation went, the negotiation result is in the `message`'s [ReasonCode](messages/ServerConnectAckMessage.html#connectackreasoncodes-reasoncode)" %}

- ### WithEventHandler(OnApplicationMessageDelegate onApplicationMessage)

The [MQTTClient](MQTTClient.html) going to be created with this `OnApplicationMessage` event handler. The `OnApplicationMessage` event is called for every application message the client receives. 

```csharp
private void OnApplicationMessage(MQTTClient client, ApplicationMessage message)
{
    // ...
}
```

- ### WithEventHandler(OnAuthenticationMessageDelegate onAuthenticationMessage)

The [MQTTClient](MQTTClient.html) going to be created with this `OnAuthenticationMessage` event handler. The `OnAuthenticationMessage` event is called when the broker requires more authentication data from the client (see the extended [authentication topic](../other/authentication.html#extended-authentication)). 

```csharp
private void OnAuthenticationCallback(MQTTClient client, AuthenticationMessage message)
{
    // ...
}
```

- ### WithEventHandler(OnErrorDelegate onError)

The [MQTTClient](MQTTClient.html) going to be created with this `OnError` event handler. The `OnError` event is called when an unexpected, unrecoverable error happens. After an `OnError` call the `MQTTClient` is is in a faulted state and will not be able to send and receive messages. 

```csharp
private void OnError(MQTTClient client, string error)
{
    // ...
}
```

- ### WithEventHandler(OnDisconnectDelegate onDisconnect)

The [MQTTClient](MQTTClient.html) going to be created with this `OnDisconnect` event handler. The `OnDisconnect` event is called when the client gracefully disconnects from the broker or after an OnError event. Graceful disconnection can be initiated by both the client or broker. 

```csharp
private void OnDisconnectDelegate(MQTTClient client, DisconnectReasonCodes reasonCode, string reasonMessage)
{
    // ...
}
```

Possible reason codes from the broker:

Reason Code | Description
--- | ---
NormalDisconnection | Close the connection normally. Do not send the [Will Message](../getting_started/last_will.html).
UnspecifiedError | The connection is closed but the sender either does not wish to reveal the reason, or none of the other Reason Codes apply.
MalformedPacket | The received packet does not conform to this specification.
ProtocolError | An unexpected or out of order packet was received.
ImplementationSpecificError | The packet received is valid but cannot be processed by this implementation.
NotAuthorized | The request is not authorized.
ServerBusy | The broker is busy and cannot continue processing requests from this client.
ServerShuttingDown | The broker is shutting down.
KeepAliveTimeout | The connection is closed because no packet has been received for 1.5 times the Keepalive time.
SessionTakenOver | Another connection using the same client ID has connected causing this connection to be closed.
TopicFilterInvalid | The [Topic Filter](../getting_started/topic_filters.html) is correctly formed, but is not accepted by this broker.
TopicNameInvalid | The [Topic Name](../getting_started/topic_filters.html) is correctly formed, but is not accepted by this broker.
ReceiveMaximumExceeded | The broker has received more than [Receive Maximum](packet_builders/ConnectPacketBuilder.html#withreceivemaximumuint16-value) publication for which it has not sent PUBACK or PUBCOMP.
TopicAliasInvalid | The broker has received a PUBLISH packet containing a [Topic Alias](MQTTClient.html#void-addtopicaliasstring-topicname) which is greater than the [Maximum Topic Alias](messages/ServerConnectAckMessage.html#uint16-topicaliasmaximum) it sent in the [connect acknowledgement](messages/ServerConnectAckMessage.html) packet.
PacketTooLarge | The packet size is greater than [Maximum Packet Size](messages/ServerConnectAckMessage.html#uint32-maximumpacketsize) for this broker.
MessageRateTooHigh | The received data rate is too high.
QuotaExceeded | An implementation or administrative imposed limit has been exceeded.
AdministrativeAction | The connection is closed due to an administrative action.
PayloadFormatInvalid | The payload format does not match the one specified by the [Payload Format Indicator](packet_builders/ApplicationMessagePacketBuilder.html#withpayloadformatindicatorpayloadtypes-payloadtype).
RetainNotSupported | The broker has does not support retained messages.
QoSNotSupported | The client specified a QoS greater than the QoS specified in a [Maximum QoS in the server connect acknowledgement](messages/ServerConnectAckMessage.html#qoslevels-maximumqos).
UseAnotherServer | The client should temporarily change its broker.
ServerMoved | The broker is moved and the client should permanently change its server location.
SharedSubscriptionsNotSupported | The broker does not support *Shared Subscriptions*.
ConnectionRateExceeded | This connection is closed because the connection rate is too high.
MaximumConnectTime | The maximum connection time authorized for this connection has been exceeded.
SubscriptionIdentifiersNotSupported | The broker does not support *Subscription Identifiers*, hence the subscription is not accepted.
WildcardSubscriptionsNotSupported | The broker does not support *Wildcard Subscriptions*, hence the subscription is not accepted.

{% include note.html content="" %}

- ### WithEventHandler(OnStateChangedDelegate onStateChanged)

The [MQTTClient](MQTTClient.html) going to be created with this `OnStateChanged` event handler. The `OnStateChanged` event is called when the internal state of the client is changed. 

```csharp
private void OnStateChanged(MQTTClient client, ClientStates oldState, ClientStates newState)
{
    // ...
}
```

#### Possible states of an `MQTTClient`

State | Description
---|---
Initial | State right after constructing the MQTTClient.
TransportConnecting | The selected transport's connection process started.
TransportConnected | Transport successfully connected to the broker.
Connected | Connect packet sent and acknowledgement received from the broker.
Disconnecting | Disconnect process initiated.
Disconnected | Client disconnected from the broker. This could be the result either of a graceful termination or an unexpected error.

- ### CreateClient()

`MQTTClient CreateClient()`

Creates the final [MQTTClient](MQTTClient.html) instance with all the options and event handlers.

## Examples

```csharp
var options = new ConnectionOptionsBuilder()
			.WithTCP("localhost", 1883)        
			.WithProtocolVersion(SupportedProtocolVersions.MQTT_3_1_1)
			.Build();
		
var client = new MQTTClientBuilder()
			.WithOptions(options)
			.WithEventHandler(OnConnected)
			.WithEventHandler(OnError)
			.WithEventHandler(OnDisconnect)
			.CreateClient();
	
// Event handler implementations:
	
private void OnConnected(MQTTClient client)
{
    Debug.Log("OnConnected()");
}

private void OnError(MQTTClient client, string error)
{
    Debug.Log($"OnError(\"{error}\")");
}

private void OnDisconnect(MQTTClient client, DisconnectReasonCodes reasonCode, string reasonMessage)
{
    Debug.Log($"OnDisconnect({reasonCode}, \"{reasonMessage}\")");
}

```

The same setup but passing the `ConnectionOptionsBuilder` to the `MQTTClientBuilder`:
```csharp
var client = new MQTTClientBuilder()
			.WithOptions(new ConnectionOptionsBuilder()
				.WithTCP("localhost", 1883)        
				.WithProtocolVersion(SupportedProtocolVersions.MQTT_3_1_1))
			.WithEventHandler(OnConnected)
			.WithEventHandler(OnError)
			.WithEventHandler(OnDisconnect)
			.CreateClient();
```