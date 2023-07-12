---
title: Azure IoT Hub with a SharedAccessKey
sidebar: best_mqtt_sidebar
summary: How to connect to an Azure IoT Hub using a SharedAccessKey.
---

This article covers how you can set up Best MQTT to connect to an Azure IoT Hub using `SharedAccesKey`s.
In this case the username field has to contain the `host name` and `device id` with the following format: `{iotHub-hostname}/{device-id}/?api-version=2021-04-12`, while the password is a [Shared Access Signature (SAS)](https://learn.microsoft.com/en-us/azure/iot-hub/iot-hub-dev-guide-sas?tabs=csharp#sas-tokens) token. 
The link above contains the code too to help generate the SAS token.

## Prerequisites

First of all, if not already, create a new device with setting/leaving Authentication type as Symmetric key. When done, or want to connect to an already set up device, open its settings and copy one of its connection strings, they look something like this: `HostName=iothub-hostname.azure-devices.net;DeviceId=device_name_with_sak;SharedAccessKey=cCWVddDpee7c+U5/qJWaX5N8VU0XYZFSIrsdBhU8Gs1=`. The connection string contains everything that required to connect to the hub.
The TLS addon isn't required, however, it adviced to use it for its added security.

## Setup Best MQTT

Have to create an MQTT connection that connects with TCP to port 8883, uses TLS for security and must use the 3.1.1 version of the MQTT protocol. Translating to code:
```csharp
var options = new ConnectionOptionsBuilder()
	.WithTCP(host, 8883)
	.WithTLS()
	.WithProtocolVersion(SupportedProtocolVersions.MQTT_3_1_1)
	.Build();

var client = new MQTTClient(options);
```

When the transport is connected we have to send an MQTT connect packet too. In this packet we have to send the username and password and the device id as the Client ID:
```csharp
private ConnectPacketBuilder OnConnectPacketBuilder(MQTTClient client, ConnectPacketBuilder builder)
{
	return builder
		.WithClientID(deviceId)
		.WithUserName($"{client.Options.Host}/{deviceId}/?api-version=2021-04-12")
		.WithPassword(GenerateSasToken(client.Options.Host, sharedAccessKey, null, 3600));
}
```

We can use the very same GenerateSasToken from the [Azure IoT Hub help pages](https://learn.microsoft.com/en-us/azure/iot-hub/iot-hub-dev-guide-sas?tabs=csharp#sas-token-structure):
```csharp
public static string GenerateSasToken(string resourceUri, string key, string policyName, int expiryInSeconds = 3600)
{
	TimeSpan fromEpochStart = DateTime.UtcNow - new DateTime(1970, 1, 1);
	string expiry = Convert.ToString((int)fromEpochStart.TotalSeconds + expiryInSeconds);

	string stringToSign = WebUtility.UrlEncode(resourceUri) + "\n" + expiry;

	HMACSHA256 hmac = new HMACSHA256(Convert.FromBase64String(key));
	string signature = Convert.ToBase64String(hmac.ComputeHash(Encoding.UTF8.GetBytes(stringToSign)));

	string token = String.Format(CultureInfo.InvariantCulture, "SharedAccessSignature sr={0}&sig={1}&se={2}", WebUtility.UrlEncode(resourceUri), WebUtility.UrlEncode(signature), expiry);

	if (!String.IsNullOrEmpty(policyName))
	{
		token += "&skn=" + policyName;
	}

	return token;
}
```

The whole code put toghether (don't forget to set the `host`, `deviceId` and `sharedAccessKey` fields from the connection string!):

```csharp
using System;
using System.Globalization;
using System.Net;
using System.Security.Cryptography;
using System.Text;

using BestMQTT;
using BestMQTT.Packets.Builders;

using UnityEngine;

public sealed class AzureIoT_SharedAccessKey : MonoBehaviour
{
	// Using a connection string that formatted like this:
    // HostName=iothub-hostname.azure-devices.net;DeviceId=device_name_with_sak;SharedAccessKey=cCWVddDpee7c+U5/qJWaX5N8VU0XYZFSIrsdBhU8Gs1=

    // from HostName
    string host = "iothub-hostname.azure-devices.net";
	
    // from DeviceId:
    string deviceId = "device_name_with_sak";

    // from SharedAccessKey
    string sharedAccessKey = "cCWVddDpee7c+U5/qJWaX5N8VU0XYZFSIrsdBhU8Gs1=";

    void Start()
    {
        var options = new ConnectionOptionsBuilder()
            .WithTCP(host, 8883)
            .WithTLS()
            .WithProtocolVersion(SupportedProtocolVersions.MQTT_3_1_1)
            .Build();

        var client = new MQTTClient(options);

        client.OnStateChanged += (c, oldState, newState) => Debug.Log($"[{c.Options.Host}]: {oldState} => {newState}");
        client.OnConnected += OnClientConnected;

        client.BeginConnect(OnConnectPacketBuilder);
    }

    private ConnectPacketBuilder OnConnectPacketBuilder(MQTTClient client, ConnectPacketBuilder builder)
    {
        return builder
            .WithClientID(deviceId)
            .WithUserName($"{client.Options.Host}/{deviceId}/?api-version=2021-04-12")
            .WithPassword(GenerateSasToken(client.Options.Host, sharedAccessKey, null, 3600));
    }

    private void OnClientConnected(MQTTClient client)
    {
        client.CreateSubscriptionBuilder($"devices/{deviceId}/messages/devicebound/#")
            .WithMessageCallback(OnDeviceMessage)
            .BeginSubscribe();
    }

    private void OnDeviceMessage(MQTTClient client, SubscriptionTopic topic, string topicName, ApplicationMessage message)
    {
        Debug.Log($"{topic}({topicName}): {System.Text.Encoding.UTF8.GetString(message.Payload.Data, message.Payload.Offset, message.Payload.Count)}");
    }


    /// <summary>
    /// From "SAS Token Structure" topic: https://learn.microsoft.com/en-us/azure/iot-hub/iot-hub-dev-guide-sas?tabs=csharp#sas-token-structure
    /// </summary>
    public static string GenerateSasToken(string resourceUri, string key, string policyName, int expiryInSeconds = 3600)
    {
        TimeSpan fromEpochStart = DateTime.UtcNow - new DateTime(1970, 1, 1);
        string expiry = Convert.ToString((int)fromEpochStart.TotalSeconds + expiryInSeconds);

        string stringToSign = WebUtility.UrlEncode(resourceUri) + "\n" + expiry;

        HMACSHA256 hmac = new HMACSHA256(Convert.FromBase64String(key));
        string signature = Convert.ToBase64String(hmac.ComputeHash(Encoding.UTF8.GetBytes(stringToSign)));

        string token = String.Format(CultureInfo.InvariantCulture, "SharedAccessSignature sr={0}&sig={1}&se={2}", WebUtility.UrlEncode(resourceUri), WebUtility.UrlEncode(signature), expiry);

        if (!String.IsNullOrEmpty(policyName))
        {
            token += "&skn=" + policyName;
        }

        return token;
    }
}
```