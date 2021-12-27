---
title: Authentication
sidebar: best_http2_main_sidebar
---

## The IAuthenticationProvider interface

To authenticate a SignalR Core session an `IAuthenticationProvider` implementation can be set to the hub connection's `AuthenticationProvider` property. The plugin implements a `DefaultAccessTokenAuthenticator` and uses it as the default authenticator.

The `IAuthenticationProvider` has the following properties and events:

- **IsPreAuthRequired**: The authentication must be run before any request made to build up the SignalR protocol if this property is true.
- **OnAuthenticationSucceded**: This event must be called when the pre-authentication succeded. When IsPreAuthRequired is false, no-one will subscribe to this event.
- **OnAuthenticationFailed**: This event must be called when the pre-authentication failed. When IsPreAuthRequired is false, no-one will subscribe to this event.
- **StartAuthentication**: This function called once, when the before the SignalR negotiation begins. If IsPreAuthRequired is false, then this step will be skipped.
- **PrepareRequest**: This function will be called for every request before sending it.
- **PrepareUri**: This function can customize the given uri. If there's no intention to modify the uri, this function should return with the parameter.

## Default Implementation

Here's the implementation of the `DefaultAccessTokenAuthenticator`:

```csharp
using System;

namespace BestHTTP.SignalRCore.Authentication
{
    public sealed class DefaultAccessTokenAuthenticator : IAuthenticationProvider
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

        public DefaultAccessTokenAuthenticator(HubConnection connection)
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
            string query = string.IsNullOrEmpty(uri.Query) ? "" : uri.Query + "&";
            UriBuilder uriBuilder = new UriBuilder(uri.Scheme, uri.Host, uri.Port, uri.AbsolutePath, query + "access_token=" + this._connection.NegotiationResult.AccessToken);
            return uriBuilder.Uri;
        }

        public void Cancel()
        { }
    }
}
```

## Using an IAuthenticationProvider implementation

An `IAuthenticationProvider` implementation can be used through the `HubConnection`'s `AuthenticationProvider`:
```csharp
hub = new HubConnection(new Uri("https://server/hub"), new JsonProtocol(new LitJsonEncoder()));
hub.AuthenticationProvider = new BestHTTP.SignalRCore.Authentication.DefaultAccessTokenAuthenticator(hub);
```