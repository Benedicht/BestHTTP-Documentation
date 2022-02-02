---
title: Azure SignalR Service
sidebar: best_http2_main_sidebar
---

## Azure SignalR Service

The plugin can connect to the an Azure SignalR Service with its default authenticator.

{% include warning.html content="When used with Azure Functions Invoke and other client to server messaging can be done through Azure Functions (HTTP requests). See [https://docs.microsoft.com/en-us/azure/azure-signalr/signalr-concept-serverless-development-config#sending-messages-from-a-client-to-the-service](https://docs.microsoft.com/en-us/azure/azure-signalr/signalr-concept-serverless-development-config#sending-messages-from-a-client-to-the-service)" %}

## Azure SignalR Service with Azure Functions Authorization

To send `x-ms-client-principal-id` header for PlayFab and `x-functions-key` for Azure Functions key the default authenticator can be modified to append these headers in `PrepareRequest`:

```csharp
using System;

using BestHTTP.SignalRCore;

public sealed class AccessTokenAuthenticatorWithAuzreFunctionAuthorization : IAuthenticationProvider
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
    private string _playFabId;
    private string _clientPrincipalId;

    public AccessTokenAuthenticatorWithAuzreFunctionAuthorization(HubConnection connection, string playFabId, string clientPrincipalId)
    {
        this._connection = connection;
        this._playFabId = playFabId;
        this._clientPrincipalId = clientPrincipalId;
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
        // Add Authorization header to http requests, add access_token param to the uri otherwise
        if (BestHTTP.Connections.HTTPProtocolFactory.GetProtocolFromUri(request.CurrentUri) == BestHTTP.Connections.SupportedProtocols.HTTP)
        {
            if (this._connection.NegotiationResult != null)
                request.SetHeader("Authorization", "Bearer " + this._connection.NegotiationResult.AccessToken);

            if (!string.IsNullOrEmpty(this._playFabId))
                request.SetHeader("x-ms-client-principal-id", this._playFabId);

            if (!string.IsNullOrEmpty(this._clientPrincipalId))
                request.SetHeader("x-functions-key", this._clientPrincipalId);
        }
        else
#if !BESTHTTP_DISABLE_WEBSOCKET
            if (BestHTTP.Connections.HTTPProtocolFactory.GetProtocolFromUri(request.Uri) != BestHTTP.Connections.SupportedProtocols.WebSocket)
            request.Uri = PrepareUriImpl(request.Uri);
#else
                ;
#endif
    }

    public Uri PrepareUri(Uri uri)
    {
        if (this._connection.NegotiationResult == null)
            return uri;

        if (uri.Query.StartsWith("??"))
        {
            UriBuilder builder = new UriBuilder(uri);
            builder.Query = builder.Query.Substring(2);

            return builder.Uri;
        }

#if !BESTHTTP_DISABLE_WEBSOCKET
        if (BestHTTP.Connections.HTTPProtocolFactory.GetProtocolFromUri(uri) == BestHTTP.Connections.SupportedProtocols.WebSocket)
            uri = PrepareUriImpl(uri);
#endif

        return uri;

    }

    private Uri PrepareUriImpl(Uri uri)
    {
        if (this._connection.NegotiationResult != null && !string.IsNullOrEmpty(this._connection.NegotiationResult.AccessToken))
        {
            string query = string.IsNullOrEmpty(uri.Query) ? "" : uri.Query + "&";
            UriBuilder uriBuilder = new UriBuilder(uri.Scheme, uri.Host, uri.Port, uri.AbsolutePath, query + "access_token=" + this._connection.NegotiationResult.AccessToken);
            return uriBuilder.Uri;
        }

        return uri;
    }

    public void Cancel()
    { }
}
```

And can be used like this:
```csharp
var hub = new HubConnection(URL, protocol);
hub.AuthenticationProvider = new AccessTokenAuthenticatorWithAuzreFunctionAuthorization(hub, "<Play Fab ID>", "<Azure Functions Key>");
```