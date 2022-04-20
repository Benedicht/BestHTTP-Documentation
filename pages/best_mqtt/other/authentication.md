---
title: Authentication
sidebar: best_mqtt_sidebar
summary: Authentication methods in Best MQTT.
---

## Username + Password Authentication

Username and password can be added to the connect packet through the `ConnectPacketBuilder`:

```csharp
var options = new ConnectionOptionsBuilder()
        .WithTCP("test.mosquitto.org", 1884)
        .Build();
client = new MQTTClient(options);
client.BeginConnect(ConnectPacketBuilderCallback);

private ConnectPacketBuilder ConnectPacketBuilderCallback(MQTTClient client, ConnectPacketBuilder builder)
{
	// Add username and password to the connect packet
    return builder.WithUserNameAndPassword("rw", "readwrite");
}
```

For those cases where only the username or password needed, the `.WithUserName` and `.WithPassword` functions can be used.

## Extended Authentication

With MQTT v5 there are two new functions available to do authentication in the `ConnectPacketBuilder`, `WithExtendedAuthenticationMethod` and `WithExtendedAuthenticationData`:

```csharp
private ConnectPacketBuilder ConnectPacketBuilderCallback(MQTTClient client, ConnectPacketBuilder builder)
{
    string token = "<token>";
    return builder
        .WithExtendedAuthenticationMethod("Bearer")
        .WithExtendedAuthenticationData(System.Text.Encoding.UTF8.GetBytes(token));
}
```

After a successful connection the server might send a re-authentication request that can be handled by subscribing to the `OnAuthenticationMessage`.

```csharp
client = new MQTTClientBuilder()
	.WithOptions(options)
	.WithEventHandler(OnAuthenticationCallback)
	.CreateClient();
	
private void OnAuthenticationCallback(MQTTClient client, AuthenticationMessage message)
{
    switch (message.ReasonCode)
    {
        // Successfully authenticated
        case AuthReasonCodes.Success: 
			break;

        // Server requires re-authentication of the client.
        case AuthReasonCodes.ReAuthenticate:
            string token = "<new token>";

            client.CreateAuthenticationPacketBuilder()
                .WithReasonCode(AuthReasonCodes.ContinueAuthentication)
                .WithAuthenticationMethod("Bearer")
                .WithAuthenticationData(System.Text.Encoding.UTF8.GetBytes(token))
                .BeginAuthenticate();
            break;

        // Server needs more data
        case AuthReasonCodes.ContinueAuthentication:
            break;
    }
}
```