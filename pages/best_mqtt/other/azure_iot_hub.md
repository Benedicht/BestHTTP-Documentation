---
title: Azure IoT Hub
sidebar: best_mqtt_sidebar
summary: How to connect to an Azure IoT Hub using X.509 Certificate Authentication.
---

## Prerequisites

[TLS Security Addon for Best HTTP/2](../../best_http2/addons/tls_security/tls_security.html) to verify server certificate and send the device's X.509 certificate.

You can follow different tutorials and guides to set up the IoT Hub and generate the required device certificate:
1. [https://garethwestern.com/posts/2020/02/17/mqtt-to-azure-iot-hub/](https://garethwestern.com/posts/2020/02/17/mqtt-to-azure-iot-hub/)
2. [https://docs.microsoft.com/en-us/azure/iot-hub/tutorial-x509-scripts](https://docs.microsoft.com/en-us/azure/iot-hub/tutorial-x509-scripts)
3. [https://github.com/Azure/azure-iot-sdk-c/blob/main/tools/CACertificates/CACertificateOverview.md](https://github.com/Azure/azure-iot-sdk-c/blob/main/tools/CACertificates/CACertificateOverview.md)

## Setup TLS Security Addon

1. Create a .pfx file from your device .crt and .key file with the following openssl command:
> openssl pkcs12 -export -out device.pfx -inkey device.key -in device.crt

## Add Client Certificate 

1. To add the device certificate open the [Certificate Manager Window](../../best_http2/addons/tls_security/CertificationManagerWindow.html) and at the bottom of the window under [Client Certificates](../../best_http2/addons/tls_security/CertificationManagerWindow.html#client-certificates) click on `Add for Domain`. 
2. Add the hostname of the IoT Hub endpoint (`xyz.azure-devices.net`) to the `Domain` field 
3. Click on the `Select Certificate` button, locate and select the device.pfx created in the first step. Click on the `Ok` button and enter the password.

If everything goes right, a new entry will appear under the Client Certificates. Every time Best MQTT connects using TLS and the server asks for a client certificate the plugin will send this certificate back to the server.

{% include note.html content="Note that the TLS Security Addon doesn't work under WebGL!" %}

## Add Client Certificate Dinamically

All MQTT client connecting to an MQTT broker must have a unique clientId. To achieve this, devices should be added to the IoT Hub and device certificates generated dinamically.

To add a certificate 
```csharp
static void TryAddDeviceCertificateToDatabase(string host, string pathToCertificate, string password)
{
    var database = TLSSecurity.ClientCredentials;

    // find out whether we already added the device's client certificate
    var certs = database.FindByTargetDomain(host);

    if (certs == null || certs.Count == 0)
    {
        var store = new BestHTTP.SecureProtocol.Org.BouncyCastle.Pkcs.Pkcs12Store(System.IO.File.OpenRead(pathToCertificate), password.ToCharArray());

        foreach (string alias in store.Aliases)
        {
            var certificate = new BestHTTP.SecureProtocol.Org.BouncyCastle.Tls.Certificate((from cert in store.GetCertificateChain(alias) select new BestHTTP.Addons.TLSSecurity.Databases.ClientCredentials.BestHTTPTlsCertificate(cert.Certificate.CertificateStructure)).ToArray());
            var privateKeyInfo = BestHTTP.SecureProtocol.Org.BouncyCastle.Pkcs.PrivateKeyInfoFactory.CreatePrivateKeyInfo(store.GetKey(alias).Key);

            database.Add(host, new BestHTTP.Addons.TLSSecurity.Databases.ClientCredentials.ClientCredential { Certificate = certificate, KeyInfo = privateKeyInfo });
        }

        database.Save();
    }
}
```

And it can be used in the `TLSSecurity.OnSetupFinished` callback:
```csharp
TLSSecurity.OnSetupFinished = () => {
    TryAddDeviceCertificateToDatabase("xyz.azure-devices.net", "<path to the .pfx file>", "<password>");
};

TLSSecurity.Setup();
```

## Setup Best MQTT

After succesfully setting up the TLS Security Addon, connecting with Best MQTT requires the following steps:
1. Use `.WithTLS` to ensure the plguin tries to connect using TLS.
2. Use `.WithProtocolVersion(SupportedProtocolVersions.MQTT_3_1_1)` as Azure IoT Hub supports MQTT v3.1.1 only.
3. Use the device name/id as the clientId in the `OnConnectPacketBuilder` callback (`.WithClientID(deviceId)` call in the code below).
4. Use the combination of the host and device id as the username in the `OnConnectPacketBuilder` callback (`.WithUserName($"{client.Options.Host}/{deviceId}")` call in the code below).

```csharp
using System;

using BestHTTP.Addons.TLSSecurity;
using BestMQTT;
using BestMQTT.Packets.Builders;

using UnityEngine;

public sealed class MQTT_AzureTest : MonoBehaviour
{
    // name/id of the device
    string deviceId = "device2";
    string host = "xyz.azure-devices.net";

    void Start()
    {
        TLSSecurity.Setup();
        
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
            .WithUserName($"{client.Options.Host}/{deviceId}");
    }

    private void OnClientConnected(MQTTClient client)
    {
        client.CreateSubscriptionBuilder($"devices/{deviceId}/#")
            .WithMessageCallback(OnDeviceMessage)
            .BeginSubscribe();
    }

    private void OnDeviceMessage(MQTTClient client, SubscriptionTopic topic, string topicName, ApplicationMessage message)
    {
        Debug.Log($"{topic}({topicName}): {System.Text.Encoding.UTF8.GetString(message.Payload.Data, message.Payload.Offset, message.Payload.Count)}");
    }
}
```