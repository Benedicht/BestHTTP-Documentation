---
title: AuthenticationPacketBuilder
sidebar: best_mqtt_sidebar
---

## Description

Using this type of builder the client can send more authentication data or reauthenticate after the broker sends an authentication request.

See also the [Extended Authentication topic](../../other/authentication.html#extended-authentication).

{% include warning.html content="Isn't available with MQTT v3.1.1!" %}

## Functions

- ### WithReasonCode(AuthReasonCodes authReason)

Reason while the authentication packet is sent. Available reason codes:

Reason Code | Description
---|---
ContinueAuthentication| Continue the authentication with another step
ReAuthenticate| Initiate a re-authentication

While the `Success` reason code also available, the client **must not** send it.

{% include note.html content="One of the reason codes must be added to the packet!" %}

- ### WithAuthenticationMethod(string method)
The name of the authentication method.

- ### WithAuthenticationData(byte[] data)
Binary data containing authentication data.

- ### WithReasonString(string reason)
Human readable text, designed for diagnostics.

- ### WithUserProperty(string key, string value)
Key-value pairs to allow sending more diagnostic data.

## Examples

```csharp
client = new MQTTClient(options);
client.OnAuthenticationMessage += OnAuthenticationCallback;

private void OnAuthenticationCallback(MQTTClient client, AuthenticationMessage message)
{
    switch (message.ReasonCode)
    {
        // Successfully authenticated
        case AuthReasonCodes.Success: break;

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