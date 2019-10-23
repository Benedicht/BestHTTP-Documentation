# Hubs
In order to define methods on the client that a Hub can call from the server, and to invoke methods on a Hub at the server, Hubs must be added to the Connection object. This can be done by adding the hub names or hub instances to the Connection constructor, demonstrated in the *Connection Class* section.

## Accessing hubs
Hub instances can be accessed through the Connection object by index, or by name.

```language-csharp
Hub hub = signalRConnection[0];
Hub hub = signalRConnection["hubName"];
```

## Register server callable methods
To handle server callable method calls, we have to call the On function of a hub:

```language-csharp
// Register method implementation
signalRConnection["hubName"].On("joined", Joined);

// "Joined" method implementation on the client
void Joined(Hub hub, MethodCallMessage msg)
{
  Debug.Log(string.Format("{0} joined at {1}", msg.Arguments[0], msg.Arguments[1]));
}
```

The MethodCallMessage is a server sent object that contains the following properties:

- **Hub**: A string containing the hub name that the method have to call on.
- **Method**: A string that contains the method name.
- **Arguments**: An array of objects that contains the arguments of the method call. It can be an empty array.
- **State**: A dictionary containing additional custom data.

The plugin will use the Hub and Method properties to route the message to the right hub and event handler. The function that handles the method call have to use only the Arguments and State properties.

## Call server-side methods
Calling server-side methods can be done by call a Hub’s Call function. The call function overloaded to be able to fulfill every needs. The Call functions are non-blocking functions, they will **not** block until the server sends back any message about the call.

The overloads are the following:

- **Call(string method, params object[] args)**: This can be used to call a server-side function in a fire-and-forget style. We will not receive back any messages about the method call’s success or failure. This function can be called without any ‘args’ arguments, to call a parameterless method.

```language-csharp
// Call a server-side function without any parameters
signalRConnection["hubName"].Call("Ping");

// Call a server-side function with two string parameters: "param1" and "param2"
signalRConnection["hubName"].Call("Message", "param1", "param2");
```

- **Call(string method, OnMethodResultDelegate onResult, params object[] args)**: This function can be used as the previous one, but a function can be passed as the second parameter that will be called when the server-side function successfully invoked.

```language-csharp
signalRConnection["hubName"].Call("GetValue", OnGetValueDone);

void OnGetValueDone(Hub hub, ClientMessage originalMessage, ResultMessage result)
{
  Debug.Log("GetValue executed on the server. Return value of the function:" + result.ReturnValue.ToString());
}
```

This callback function receives the Hub that called this function, the original ClientMessage message that sent to the server and the ResultMessage instance sent by the server as a result of the method call. A ResultMessage object contains a ReturnValue and a State properties.

If the method’s return type is void, the ReturnValue is null.

- **Call(string method, OnMethodResultDelegate onResult, OnMethodFailedDelegate onError, params object[] args)**: This function can be used to specify a callback that will be called when the method fails to run on the server. Failures can be happen because of a non-found method, wrong parameters, or unhandled exceptions in the method call.

```language-csharp
signalRConnection["hubName"].Call("GetValue", OnGetValueDone, OnGetValueFailed);

void OnGetValueFailed(Hub hub, ClientMessage originalMessage, FailureMessage error)
{
  Debug.Log("GetValue failed. Error message from the server: " + error.ErrorMessage);
}
```

A FailureMessage contains the following properties:

- 	
	- **IsHubError**: True if it is a Hub error.
	- **ErrorMessage**: A brief message about the error itself.
	- **StackTrace**: If detailed error reporting is turned on on the server then it contains the stack trace of the error.
	- **AdditionalData**: If it’s not null, then it contains additional information about the error.

- **Call(string method, OnMethodResultDelegate onResult, OnMethodFailedDelegate onError, OnMethodProgressDelegate onProgress, params object[] args**): This function can be used to add an additional progress message handler to the server-side method call. For long running jobs the server can send progress messages to the client.

```language-csharp
signalRConnection["hubName"].Call("GetValue", OnGetValueDone, OnGetValueFailed, OnGetValueProgress);

void OnGetValueProgress(Hub hub, ClientMessage originalMessage,
ProgressMessage progress)
{
  Debug.Log(string.Format("GetValue progressed: {0}%", progress.Progress));
}
```

When a ResultMessage or FailureMessage received by the plugin, it will not serve the ProgressMessages that came after these messages.

## Using the Hub class as a base class to inherit from
The Hub class can be used as a base class to encapsulate hub functionality.

```language-csharp
class SampleHub : Hub
{
 // Default constructor. Every hubs have to have a valid name.
 public SampleHub()
   :base("SampleHub")
 {
	// Register a server-callable function
	base.On("ClientFunction", ClientFunctionImplementation);
 }

 // Private function to implement server-callable function
 private void ClientFunctionImplementation(Hub hub, MethodCallMessage msg)
 {
   // TODO: implement
 }

 // Wrapper function to call a server-side function.
 public void ServerFunction(string argument)
 {
	base.Call("ServerFunction", argument);
 }
}
```

This SampleHub can be instantiated and passed to the Connection’s constructor:

```language-csharp
SampleHub sampleHub = new SampleHub();
Connection signalRConnection = new Connection(Uri, sampleHub);
```

## Authentication
The Connection class has an AuthenticationProvider property that can be set to an object that  implements the IAuthenticationProvider interface.
The implementor has to implement the following property and functions:

- **bool IsPreAuthRequired**:Property that returns true, if the authentication must run before any request is made to the server by the Connection class. Examples: a cookie authenticator must return false, as it has to send user credentials and receive back a cookie that must sent with the requests.
- **StartAuthentication**: A function that required only if the IsPreAuthRequired is true. Otherwise it doesn’t called.
- **PrepareRequest**: A function that is called with a request and a request type enum. This function can be used to prepare requests before they are sent to the server.
- **OnAuthenticationSucceded**: An event that must be called when the IsPreAuthRequired is true and the authentication process succeeded.
- **OnAuthenticationFailed**: An event that must be called when the IsPreAuthRequired is true and the authentication process failed.

A very simple Header-based authenticator would look like this:

```language-csharp
class HeaderAuthenticator : IAuthenticationProvider
{
   public string User { get; private set; }
   public string Roles { get; private set; }

   // No pre-auth step required for this type of authentication
   public bool IsPreAuthRequired { get { return false; } }

   // Not used event as IsPreAuthRequired is false
   public event OnAuthenticationSuccededDelegate OnAuthenticationSucceded;

   // Not used event as IsPreAuthRequired is false
   public event OnAuthenticationFailedDelegate OnAuthenticationFailed;

   // Constructor to initialise the authenticator with username and roles.
   public HeaderAuthenticator(string  user, string roles)
   {
  	 this.User = user;
  	 this.Roles = roles;
   }

   // Not used as IsPreAuthRequired is false
   public void StartAuthentication()
   { }

   // Prepares the request by adding two headers to it
   public void PrepareRequest(BestHTTP.HTTPRequest request, RequestTypes type)
   {
  	 request.SetHeader("username", this.User);
  	 request.SetHeader("roles", this.Roles);
   }
}
```

## Writing custom Json encoders
Like for the Socket.IO’s Manager class, the SignalR’s Connection class has a JsonEncoder property, and the static Connection.DefaultEncoder can be set too.
A JsonEncoder must implement the IJsonEncoder interface from the BestHTTP.SignalR.JsonEncoders namespace.
The package contains a sample LitJsonEncoder, that also used by some samples too.
