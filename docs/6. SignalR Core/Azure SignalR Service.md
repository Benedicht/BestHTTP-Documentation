# How to connect to an Azure SignalR Service

Here's a sample implementation to connect to an Azure SignalR Serverice:

```language-csharp
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
 
using BestHTTP.SignalRCore;
using System;
using BestHTTP;
 
public class SignalRService : MonoBehaviour {
 
    // Use this for initialization
    void Start () {
        var conn = new HubConnection(new Uri("http://localhost:5000/chat"), new JsonProtocol(new BestHTTP.SignalRCore.Encoders.LitJsonEncoder()));
        conn.AuthenticationProvider = new AzureSignalRServiceAuthenticator(conn);
        conn.OnConnected += OnConnected;
		
        conn.On<string, string>("BroadcastMessage", OnBroadcastMessage);
		
        conn.StartConnect();
    }
 
    private void OnBroadcastMessage(string name, string message)
    {
        Debug.LogFormat("[{0}]: {1}", name, message);
    }
 
    private void OnConnected(HubConnection hub)
    {
        hub.Send("BroadcastMessage", "Best HTTP Client", "Hello World!");
    }
}
 
public sealed class AzureSignalRServiceAuthenticator : IAuthenticationProvider
{
    /// <summary>
    /// No pre-auth step required for this type of authentication
    /// </summary>
    public bool IsPreAuthRequired { get { return false; } }
 
#pragma warning disable 0067
    /// <summary>
    /// Not used event as IsPreAuthRequired is false
    /// </summary>
    public event OnAuthenticationSuccededDelegate OnAuthenticationSucceded;
 
    /// <summary>
    /// Not used event as IsPreAuthRequired is false
    /// </summary>
    public event OnAuthenticationFailedDelegate OnAuthenticationFailed;
 
#pragma warning restore 0067
 
    private HubConnection _connection;
 
    public AzureSignalRServiceAuthenticator(HubConnection connection)
    {
        this._connection = connection;
    }
 
    /// <summary>
    /// Not used as IsPreAuthRequired is false
    /// </summary>
    public void StartAuthentication()
    { }
 
    /// <summary>
    /// Prepares the request by adding two headers to it
    /// </summary>
    public void PrepareRequest(BestHTTP.HTTPRequest request)
    {
        if (this._connection.NegotiationResult == null)
            return;
 
        // Add Authorization header to http requests, add access_token param to the uri otherwise
        if (BestHTTP.Connections.HTTPProtocolFactory.GetProtocolFromUri(request.CurrentUri) == BestHTTP.Connections.SupportedProtocols.HTTP)
            request.SetHeader("Authorization", "Bearer " + this._connection.NegotiationResult.AccessToken);
        else
            request.Uri = PrepareUriImpl(request.Uri);
    }
 
    public Uri PrepareUri(Uri uri)
    {
        if (uri.Query.StartsWith("??"))
        {
            UriBuilder builder = new UriBuilder(uri);
            builder.Query = builder.Query.Substring(2);
 
            return builder.Uri;
        }
 
        return uri;
    }
 
    private Uri PrepareUriImpl(Uri uri)
    {
        string query = string.IsNullOrEmpty(uri.Query) ? "" : uri.Query + "&";
        UriBuilder uriBuilder = new UriBuilder(uri.Scheme, uri.Host, uri.Port, uri.AbsolutePath, query + "access_token=" + this._connection.NegotiationResult.AccessToken);
        return uriBuilder.Uri;
    }
}
```

!!! Warning
	When used with Azure Functions Invoke and other client to server messaging can be done through Azure Functions (HTTP requests). See [https://docs.microsoft.com/en-us/azure/azure-signalr/signalr-concept-serverless-development-config#sending-messages-from-a-client-to-the-service](https://docs.microsoft.com/en-us/azure/azure-signalr/signalr-concept-serverless-development-config#sending-messages-from-a-client-to-the-service)