---
title: Azure SignalR Service
sidebar: best_http2_main_sidebar
---

# Connect to PlayFab PubSub

Authenticator implementation that can be used with PlayFab:

```csharp
public sealed class PlayFabAuthenticator : IAuthenticationProvider
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
    private string _entityToken;

    public PlayFabAuthenticator(HubConnection connection, string entityToken)
    {
        this._connection = connection;
        this._entityToken = entityToken;
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
        if (this._connection.NegotiationResult == null) {
            request.SetHeader("X-EntityToken", this._entityToken);
            return;
        }

        // Add Authorization header to http requests, add access_token param to the uri otherwise
        if (BestHTTP.Connections.HTTPProtocolFactory.GetProtocolFromUri(request.CurrentUri) == BestHTTP.Connections.SupportedProtocols.HTTP)
            request.SetHeader("Authorization", "Bearer " + this._connection.NegotiationResult.AccessToken);
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

The only main change differentiating it from the default access-token authenticator is that this one sets the `X-EntityToken` header in the `PrepareRequest` method.

And it can be used while setting up the `HubConnection` object:
```csharp
string titleId = "...";
string entityToken = "...";

var connection = new HubConnection(new Uri($"https://{titleId}.playfabapi.com/pubsub"), new JsonProtocol(new LitJsonEncoder()));
connection.AuthenticationProvider = new PlayFabAuthenticator(connection, entityToken);

// add callbacks, etc.

connection.StartConnect();
```