---
title: Client Setup
sidebar: best_mqtt_sidebar
summary: A step-by-step guide to set up and use MQTTClient.
---

## Installation

Using [Unity Editor's Package Manager window](https://docs.unity3d.com/Manual/upm-ui.html) import the [Best HTTP/2](https://assetstore.unity.com/packages/tools/network/best-http-2-155981?aid=1101lfX8E) package first, then Best MQTT itself. If all packages are imported properly, no further steps are required.

## Initial setup

After successfully imported both the Best MQTT and Best HTTP/2 packages, you can create a new C# Script file in your Unity project and add the plugin's namespace '`BestMQTT`' and '`BestMQTT.Packets.Builders`' somewhere around the other usings and delete the Update function as we will not going to use it:

```csharp
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using BestMQTT;
using BestMQTT.Packets.Builders;

public class MQTT : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }
}
```

Create a new scene in Unity and assign this script to a gameobject.

## Creating a ConnectionOptions instance

First we have to create a `ConnectionOptions` instance to pass it to the `MQTTClient`'s constructor in the next step. `ConnectionOptions` contains connection related information like the `Host` and `Port` properties. The easiest way to create a `ConnectionOptions` is using `ConnectionOptionsBuilder`:
```csharp
var options = new ConnectionOptionsBuilder()
    .WithTCP("broker.emqx.io", 1883)
    .Build();
```

The `WithTCP("broker.emqx.io", 1883)` line tells the plugin to try to connect to the "broker.emqx.io" host with port 1883 using the TCP transport. If we want to use TLS to encrypt the server-client communication add the .WithTLS() call:
```csharp
var options = new ConnectionOptionsBuilder()
    .WithTCP("broker.emqx.io", 8883)
    .Build();
```

In this guide i used [EMQ X's public broker](https://www.emqx.com/en/mqtt/public-mqtt5-broker), but there are many others to [choose from](https://github.com/mqtt/mqtt.org/wiki/public_brokers).

{% include callout.html type="primary" content="The server must support TLS v1.1 or v1.2 and hosted on a different port!" %}

To use Websocket as the transport protocol instead of `WithTCP` the `WithWebSocket` function must be used.

{% include callout.html type="warning" content="The TCP transport isn't available under WebGL!" %}

## Creating the MQTTClient

With the newly created ConnectionOptions instance we can create the `MQTTClient` instance:

```csharp
var client = new MQTTClient(options);
```

## Add general events

The client going to start to connect to the server when instructed so with BeginConnect` or `ConnectAsync`. We can freely add and modify the client until one of these are called without fearing that any event is missed. Let's add a few event handlers to catch client related events:

```csharp
client.OnStateChanged += OnStateChanged;
client.OnDisconnect += OnDisconnected;
client.OnError += OnError;
```

And add the implementation of the event handlers:
```csharp
// Called when the MQTTClient transfered to a new internal state.
private void OnStateChanged(MQTTClient client, ClientStates oldState, ClientStates newState)
{
    Debug.Log($"{oldState} => {newState}");
}

// Called when the client disconnects from the server. The disconnection can be client or server initiated or because of an error.
private void OnDisconnected(MQTTClient client, DisconnectReasonCodes code, string reason)
{
    Debug.Log($"OnDisconnected - code: {code}, reason: '{reason}'");
}

// Called when an error happens that the plugin can't recover from. After this event an OnDisconnected event is raised too.
private void OnError(MQTTClient client, string reason)
{
    Debug.Log($"OnError reason: '{reason}'");
}
```

These events are not tightly related to the MQTT protocol, but they can give a good understanding when and what happens with the client connection.

A more compact way to create and setup `ClientOptions` and the client itself is to use `MQTTClientBuilder`:
```csharp
client = new MQTTClientBuilder()
                .WithOptions(new ConnectionOptionsBuilder().WithTCP("broker.emqx.io", 1883))
                .WithEventHandler(OnStateChanged)
                .WithEventHandler(OnDisconnected)
                .WithEventHandler(OnError)
                .CreateClient();
```

All of the event handlers have different signatures so they will be mapped to the right event.

## Connecting

So far we done a basic setup of the client and added a few event handlers, but still not connected to the mqtt server. To start connecting to the server we can add a `BeginConnect` call after the client setup:
```csharp
client.BeginConnect(ConnectPacketBuilderCallback);

private ConnectPacketBuilder ConnectPacketBuilderCallback(MQTTClient client, ConnectPacketBuilder builder)
{
    return builder;
}
```

`BeginConnect` expects a function that returns with a connect packet builder. The builder is used to build the MQTT connect packet **after** the transport successfully connected to the server. Through this builder we can set up basic authentication, a will, customize negotiable values like keep alive intervals and many more. For now we can leave it as is, just returning the builder received in the second parameter.
Now we can test it and when run in Unity the Console should show something like this:

{% include image.html file="media\events_log.png" %}

{% include note.html content="`BeginConnect` and other functions starting with 'Begin' are non-blocking! To execute code after connected an `OnConnected` event handler must be added." %}

## And disconnecting

It's advised to disconnect when the MQTT client no longer needed. To disconnect, at a bare minimum we have to call the `MQTTClient`'s `CreateDisconnectPacketBuilder`, optionally call its `With*` functions then finally `BeginDisconnect` to send the disconnect packet to the server and let the plugin do its cleanup.

In this example we are going to set the reason code and send a nice message to the server too:

```csharp
private void OnDestroy()
{
    client?.CreateDisconnectPacketBuilder()
        .WithReasonCode(DisconnectReasonCodes.NormalDisconnection)
        .WithReasonString("Bye")
        .BeginDisconnect();
}
```

The plugin heavily uses the builder pattern as there are a lot of optional fields that can be sent. This is the case with disconnection too. When `client.CreateDisconnectPacketBuilder().BeginDisconnect()` is used it's going to send a `DisconnectReasonCodes.NormalDisconnection` without any additional data.

Now entering to and exiting from play mode in Unity should generate the following output in the console:
{% include image.html file="media\disconnect_log.png" %}

## Final code

Putting it all together, the whole file should look like something like this:

```csharp
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using BestMQTT;
using BestMQTT.Packets.Builders;

public class MQTT : MonoBehaviour
{
    MQTTClient client;

    // Start is called before the first frame update
    void Start()
    {
        client = new MQTTClientBuilder()
                        .WithOptions(new ConnectionOptionsBuilder().WithTCP("broker.emqx.io", 1883))
                        .WithEventHandler(OnDisconnected)
                        .WithEventHandler(OnStateChanged)
                        .WithEventHandler(OnError)
                      .CreateClient();

        client.BeginConnect(ConnectPacketBuilderCallback);
    }

    private void OnDestroy()
    {
        client?.CreateDisconnectPacketBuilder()
            .WithReasonCode(DisconnectReasonCodes.NormalDisconnection)
            .WithReasonString("Bye")
            .BeginDisconnect();
    }

    private ConnectPacketBuilder ConnectPacketBuilderCallback(MQTTClient client, ConnectPacketBuilder builder)
    {
        return builder;
    }

    private void OnStateChanged(MQTTClient client, ClientStates oldState, ClientStates newState)
    {
        Debug.Log($"{oldState} => {newState}");
    }

    private void OnDisconnected(MQTTClient client, DisconnectReasonCodes code, string reason)
    {
        Debug.Log($"OnDisconnected - code: {code}, reason: '{reason}'");
    }

    private void OnError(MQTTClient client, string reason)
    {
        Debug.Log($"OnError reason: '{reason}'");
    }
}
```
