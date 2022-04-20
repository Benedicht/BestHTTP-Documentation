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

```csharp
public enum DisconnectReasonCodes : byte
{
    NormalDisconnection = 0x00,
    DisconnectWithWillMessage = 0x04,

    UnspecifiedError = 0x80,
    MalformedPacket = 0x81,
    ProtocolError = 0x82,
    ImplementationSpecificError = 0x83,
    NotAuthorized = 0x87,
    ServerBusy = 0x89,
    ServerShuttingDown = 0x8B,
    KeepAliveTimeout = 0x8D,
    SessionTakenOver = 0x8E,
    TopicFilterInvalid = 0x8F,
    TopicNameInvalid = 0x90,
    ReceiveMaximumExceeded = 0x93,
    TopicAliasInvalid = 0x94,
    PacketTooLarge = 0x95,
    MessageRateTooHigh = 0x96,
    QuotaExceeded = 0x97,
    AdministrativeAction = 0x98,
    PayloadFormatInvalid = 0x99,
    RetainNotSupported = 0x9A,
    QoSNotSupported = 0x9B,
    UseAnotherServer = 0x9C,
    ServerMoved = 0x9D,
    SharedSubscriptionsNotSupported = 0x9E,
    ConnectionRateExceeded = 0x9F,
    MaximumConnectTime = 0xA0,
    SubscriptionIdentifiersNotSupported = 0xA1,
    WildcardSubscriptionsNotSupported = 0xA2,
}
```

- ### WithEventHandler(OnStateChangedDelegate onStateChanged)

The [MQTTClient](MQTTClient.html) going to be created with this `OnStateChanged` event handler. The `OnStateChanged` event is called when the internal state of the client is changed. 

```csharp
private void OnStateChanged(MQTTClient client, ClientStates oldState, ClientStates newState)
{
    // ...
}
```

#### Possible states of an `MQTTClient`

1. **Initial**: State right after constructing the MQTTClient.
2. **TransportConnecting**: The selected transport's connection process started.
3. **TransportConnected**: Transport successfully connected to the broker.
4. **Connected**: Connect packet sent and acknowledgement received from the broker.
5. **Disconnecting**: Disconnect process initiated.
6. **Disconnected**: Client disconnected from the broker. This could be the result either of a graceful termination or an unexpected error.

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