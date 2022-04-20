---
title: SessionHelper
sidebar: best_mqtt_sidebar
---

## Description

Static class to help manage sessions.

## Functions

- ### CreateNullSession(string host)

Creates and returns with a [Null session](../getting_started/sessions.html#null-sessions). When a null session is used the client let the broker assign a client id to the client.

- ### IEnumerable<Session> GetSessions(string host)

Returns with all the sessions for the given host.

- ### bool HasAny(string host)

Returns true if there's at least one stored session for the given host.

- ### Session Get(string host, string clientId = null)

Loads the session with the matching `clientId` or creates a new one with it. If `clientId` is null either the last used session is used or if there's no previous session found it creates one with a random ID.

- ### void Delete(string host, Session session)

Removes the session from the session list of the given host.

## Examples

This example creates 
```csharp
// Create the client
var client = new ConnectionOptionsBuilder()
        .WithTCP("localhost", 1883)
        .CreateClient();
		
// Set an OnConnected callback to log out the broker assigned client ID
client.OnConnected += OnConnected;
		
// Begin the connection process to the broker and pass a callback function to create/modify a ConnectPacketBuilder
client.BeginConnect(ConnectPacketBuilderCallback);

private ConnectPacketBuilder ConnectPacketBuilderCallback(MQTTClient client, ConnectPacketBuilder builder)
{
    // Get the broker's host from the MQTTClient
    var host = client.Options.Host;

    // If no previous session is created assign a Null session to the builder
    if (!SessionHelper.HasAny(host))
    {
        Debug.Log("Creating null session!");
        builder = builder.WithSession(SessionHelper.CreateNullSession(host));
    }
    else
        Debug.Log("A session already present for this host.");

    return builder;
}

private void OnConnected(MQTTClient client)
{
    // Get the session and print out the broker assigned client ID
	var session = SessionHelper.Get(client.Options.Host);
    Debug.Log(session.ClientId);

    // ...
}
```