#Server-Sent Events (EventSource)

The Server-Sent Events is a one-way string-based protocol. Data comes from the server, and there are no option to send anything to the server. It’s implemented using the [latest draft](http://www.w3.org/TR/eventsource/).
While the protocol’s name is Server-Sent Events, the class itself is named EventSource.

When an error occurs, the plugin will try to reconnect once sending the LastEventId to let the server send any buffered message that we should receive.

##The EventSource class
The EventSource class is located in the BestHTTP.ServerSentEvents namespace:

```csharp
using BestHTTP.ServerSentEvents;

var sse = new EventSource(new Uri("http://server.com"));
```

##Properties
These are the publicly exposed properties of the EventSource class:

- **Uri**: This is the endpoint where the protocol tries to connect to. It’s set through the constructor.
- **State**: The current state of the EventSource object.
- **ReconnectionTime*: How much time to wait to try to do a reconnect attempt. It’s default value is 2 sec.
- **LastEventId**: The last received event’s id. It will be null, if no event id received at all.
- **InternalRequest**: The internal HTTPRequest object that will be sent out in the Open function.

##Events

- **OnOpen**: It’s called when the protocol is successfully upgraded.

```csharp
eventSource.OnOpen += OnEventSourceOpened;

void OnEventSourceOpened(EventSource source)
{
Debug.log("EventSource Opened!");
}
```

- **OnMessage**: It’s called when the client receives a new message from the server. This function will receive a Message object that contains the payload of the message in the Data property. This event is called every time the client receives a message, even when the message has a valid Event name, and we assigned an event handler to this event!

```csharp
eventSource.OnMessage += OnEventSourceMessage;

void OnEventSourceMessage(EventSource source, Message msg)
{
Debug.log("Message: " + msg.Data);
}
```

- **OnError**: Called when an error encountered while connecting to the server, or while processing the data stream.

```csharp
eventSource.OnError += OnEventSourceError;

void OnEventSourceError(EventSource source, string error)
{
Debug.log("Error: " + error);
}
```

- **OnRetry**: This function is called before the plugin will try to reconnect to the server. If the function returns false, no attempt will be made and the EventSource will be closed.

```csharp
eventSource.OnRetry += OnEventSourceRetry;

bool OnEventSourceRetry(EventSource source)
{
// disable retry
return false;
}
```

- **OnClosed**: This event will be called when the EventSource closed.

```csharp
eventSource.OnClosed += OnEventSourceClosed;

void OnEventSourceClosed(EventSource source)
{
Debug.log("EventSource Closed!");
}
```

- **OnStateChanged**: Called every time when the State property changes.

```csharp
eventSource.OnStateChanged += OnEventSourceStateChanged;

void OnEventSourceStateChanged(EventSource source, States oldState, States newState)
{
Debug.log(string.Format("State Changed {0} => {1}", oldState, newState)));
}
```

##Functions
These are the public functions of the EventSource object.

- **Open**: Calling this function the plugin will start to connect to the server and upgrade to the Server-Sent Events protocol.

```csharp
EventSource eventSource = new EventSource(new Uri("http://server.com"));
eventSource.Open();
```

- **On**: Using this function clients can subscribe to events.

```csharp
eventSource.On("userLogon", OnUserLoggedIn);

void OnUserLoggedIn(EventSource source, Message msg)
{
Debug.log(msg.Data);
}
```

- **Off**: It can be used to unsubscribe from an event.

```csharp
eventSource.Off("userLogon");
```

- **Close**: This function will start to close the EventSource object.

```csharp
eventSource.Close();
```

##The Message class
The Message class is a logical unit that contains all the information that a server can send.
###Properties
- **Id**: Id of the sent event. Can be null, if no id sent. It’s used by the plugin.
- **Event**: Name of the event. Can be null, if no event name sent.
- **Data**: The actual payload of the message.
- **Retry**: A server sent time that the plugin should wait before a reconnect attempt. It’s used by the plugin.
