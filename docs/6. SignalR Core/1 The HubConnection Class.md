# The HubConnection Class

The `HubConnection` is the main entry point for a SignalR Core connection.

## Protocols

SignalR Core supports different protocols to encode its messages like Json and MessagePack. The safest is to use json, as that's the default encoder of the server. But if possible it's recommended to use MessagePack. More can be read about this under the [Encoders topic](Encoders.md).
On this page the `JsonProtocol` combined with the `LitJsonEncoder` will be used, as these work out of the box.

A new `HubConnection` object must be initialized with the uri of the server endpoint and with the protocol that the client want to communicate with:
```language-csharp
hub = new HubConnection(new Uri("https://server/hub"), new JsonProtocol(new LitJsonEncoder()));
```

## HubOptions

`HubConnection`'s constructor can accept a `HubOptions` instance too:
```language-csharp
HubOptions options = new HubOptions();
hub = new HubConnection(new Uri("https://server/hub"), new JsonProtocol(new LitJsonEncoder()), options);
```
</br>
`HubOptions` contains the following properties to set:

- **SkipNegotiation**: When this is set to true, the plugin will skip the negotiation request if the PreferedTransport is WebSocket. Its default value is false.
- **PreferedTransport**: The preferred transport to choose when more than one available. Its default value is TransportTypes.WebSocket. When the plugin can't connect with the preferred transport it will try the next available (long polling). If all transport fails to connect, it will emit an OnError event.
- **PingInterval**: A ping message is only sent if the interval has elapsed without a message being sent. Its default value is 15 seconds.
- **PingTimeoutInterval**: If the client doesn't see any message in this interval, considers the connection broken. Its default value is 30 seconds.
- **MaxRedirects**: The maximum count of redirect negoitiation result that the plugin will follow. Its default value is 100.

## Events

- **OnConnected**: This event is called when successfully connected to the hub.
- **OnError**: This event is called when an unexpected error happen and the connection is closed.
- **OnClosed**: This event is called when the connection is gracefully terminated.
- **OnMessage**: This event is called for every server-sent message. When returns false, no further processing of the message is done by the plugin.
- **OnReconnecting**: Called when the HubConnection start its reconnection process after loosing its underlying connection.
- **OnReconnected**: Called after a succesfull reconnection.
- **OnRedirected**: This event is called when the connection is redirected to a new uri.
- **OnTransportEvent**: Called for transport related events:
	- *SelectedToConnect*: Transport is selected to try to connect to the server
	- *FailedToConnect*: Transport failed to connect to the server. This event can occur after SelectedToConnect, when already connected and an error occurs it will be a ClosedWithError one.
	- *Connected*: The transport successfully connected to the server.
	- *Closed*: Transport gracefully terminated.
	- *ClosedWithError*: Unexpected error occured and the transport can't recover from it.

## Properties

- **Uri**: Uri of the Hub endpoint
- **State**: Current state of the connection.
- **Transport**: Current, active ITransport instance.
- **Protocol**: The IProtocol implementation that will parse, encode and decode messages.
- **AuthenticationProvider**: An IAuthenticationProvider implementation that will be used to authenticate the connection. Its default value is an instance of the `DefaultAccessTokenAuthenticator` class.
- **NegotiationResult**: Negotiation response sent by the server.
- **Options**: Options that has been used to create the HubConnection.
- **RedirectCount**: How many times this connection is redirected.
- **ReconnectPolicy**: The reconnect policy that will be used when the underlying connection is lost. Its default value is null.

## Connecting to the server



## Invoking server methods

To invoke a method on a server that doesn't return a value, the `Send` and `SendAsync` methods can be used.

Client code:
```language-csharp
hub.Send("Send", "my message");

await hub.SendAsync("Send", "my message");
```

Its first parameter is the name of the method on the server, than a parameter list can be passed that will be sent to the server.

Related server code:
```language-csharp
public class TestHub : Hub
{
    public Task Send(string message)
    {
        return Clients.All.SendAsync("Send", $"{Context.ConnectionId}: {message}");
    }
}
```

## Invoking server functions

Invoking a server function can be done with the generic `Invoke<TResult>` or `InvokeAsync<TResult>` functions. `TResult` is the expected type that the server function returns with.

Sample:
```language-csharp
hub.Invoke<int>("Add", 10, 20)
    .OnSuccess(result => Debug.log("10+20: " + result))
    .OnError(error => Debug.log("Add(10, 20) failed to execute. Error: " + error));
	
var addResult = await hub.InvokeAsync<int>("Add", 10, 20);
AddText(string.Format("'<color=green>Add(10, 20)</color>' returned: '<color=yellow>{0}</color>'", addResult)).AddLeftPadding(20);
```

`Invoke` returns with an `IFuture<TResult>` that can be used to subscribe to various Invoke related events:

- **OnSuccess**: Callback passed for OnSuccess is called when the server side function is executed and the callback's parameter will be function's return value.
- **OnError**: Callback passed to this function will be called when there's an error executing the function. The error can be a client or server error. The callback's error parameter will contain information about the error.
- **OnComplete**: Callback passed to this function will be called after an *OnSuccess* **or** *OnError* callback.

`InvokeAsync` returns with `Task<TResult>` that can be awaited.

Related server code:
```language-csharp
public class TestHub : Hub
{
    public int Add(int x, int y)
    {
        return x + y;
    }
}
```

## Server callable client methods

Clients can define server-callable methods using the generic and non-generic `On` method. The non-generic `On` can be used when the server-callable method has no parameter and the generic one for methods with at least one parameter.

Samples:
```language-csharp
// Generic On with one string argument.
hub.On("Send", (string arg) => Debug.log("Server-sent text: " + arg));

// Generic On, with one type:
hub.On<Person>("Person", (person) => Debug.log("Server-sent data: " + person.ToString()));

// Generic On, with two types:
hub.On<Person, Person>("TwoPersons", (person1, person2) => Debug.log("..."));

sealed class Person
{
    public string Name { get; set; }
    public long Age { get; set; }

    public override string ToString()
    {
        return string.Format("[Person Name: '{0}', Age: '<color=yellow>{1}</color>']", this.Name, this.Age.ToString());
    }
}
```

Related server code:
```language-csharp
public class TestHub : Hub
{
	public override async Task OnConnectedAsync()
    {
        await Clients.All.SendAsync("Send", $"{Context.ConnectionId} joined");

        await Clients.Client(Context.ConnectionId).SendAsync("Person", new Person { Name = "Person 007", Age = 35 });
		
        await Clients.Client(Context.ConnectionId).SendAsync("TwoPersons", new Person { Name = "Person 008", Age = 36 }, new Person { Name = "Person 009", Age = 37 });
    }
}
```

## Streaming from the server

When the server sends one return value at a time the client can call a callback for every item if the server function is called using the `GetDownStreamController<TDown>` function.

Sample:
```language-csharp
hub.GetDownStreamController<Person>("GetRandomPersons", 20, 2000)
    .OnItem(result => Debug.log("New item arrived: " + result.ToString()))
    .OnSuccess(_ => Debug.log("Streaming finished!"));
```

`GetDownStreamController`'s return value is a `DownStreamItemController<TDown>` that implements the `IFuture<TResult>` interface. With DownStreamItemController's OnItem function it can be subscribed for a callback that will be called for every downloaded item.
The instance of `DownStreamItemController<TDown>` can be used to cancel the streaming:
```language-csharp
var controller = hub.GetDownStreamController<int>("ChannelCounter", 10, 1000);

controller.OnItem(result => Debug.log("New item arrived: " + result.ToString()))
          .OnSuccess(_ => Debug.log("Streaming finished!"))
          .OnError(error => Debug.log("Error: " + error));

// A stream request can be cancelled any time by calling the controller's Cancel method
controller.Cancel();
```

Related server code:
```language-csharp
public class TestHub : Hub
{
	public ChannelReader<Person> GetRandomPersons(int count, int delay)
	{
		var channel = Channel.CreateUnbounded<Person>();

		Task.Run(async () =>
		{
			Random rand = new Random();
			for (var i = 0; i < count; i++)
			{
				await channel.Writer.WriteAsync(new Person { Name = "Name_" + rand.Next(), Age = rand.Next(20, 99) });
				
				await Task.Delay(delay);
			}

			await Clients.Client(Context.ConnectionId).SendAsync("Person", new Person { Name = "Person 000", Age = 0 });
			
			channel.Writer.TryComplete();
		});

		return channel.Reader;
	}
}
```

## Streaming to the server

To stream one or more parameters to a server function the `GetUpStreamController` can be used:
```language-csharp
private IEnumerator UploadWord()
{
    var controller = hub.GetUpStreamController<string, string>("UploadWord");
    controller.OnSuccess(result =>
        {
			Debug.log("Upload finished!");
        });

    yield return new WaitForSeconds(_yieldWaitTime);
    controller.UploadParam("Hello ");

    yield return new WaitForSeconds(_yieldWaitTime);
    controller.UploadParam("World");

    yield return new WaitForSeconds(_yieldWaitTime);
    controller.UploadParam("!!");

    yield return new WaitForSeconds(_yieldWaitTime);

    controller.Finish();
}
```

`GetUpStreamController` is a generic function, its first type-parameter is the return type of the function then 1-5 types can be added as parameter types. The `GetUpStreamController` call returns an `UpStreamItemController` instance that can be used to upload parameters (`UploadParam`), `Finish` or `Cancel` the uploading. 

It also implements the `IDisposable` interface so it can be used in a using statement and will call Finish when disposed. Here's the previous sample using the IDisposable pattern:
```language-csharp
using (var controller = hub.GetUpStreamController<string, string>("UploadWord"))
{
    controller.OnSuccess(_ =>
        {
			Debug.log("Upload finished!");
        });

    yield return new WaitForSeconds(_yieldWaitTime);
    controller.UploadParam("Hello ");

    yield return new WaitForSeconds(_yieldWaitTime);
    controller.UploadParam("World");

    yield return new WaitForSeconds(_yieldWaitTime);
    controller.UploadParam("!!");

    yield return new WaitForSeconds(_yieldWaitTime);
}
```

The controller also implements the `IFuture` interface to be able to subscribe to the `OnSuccess`, `OnError` and `OnComplete`.

Related server code:
```language-csharp
public class UploadHub : Hub 
{
	public async Task<string> UploadWord(ChannelReader<string> source)
	{
		var sb = new StringBuilder();

		// receiving a StreamCompleteMessage should cause this WaitToRead to return false
		while (await source.WaitToReadAsync())
		{
			while (source.TryRead(out var item))
			{
				Debug.WriteLine($"received: {item}");
				Console.WriteLine($"received: {item}");
				sb.Append(item);
			}
		}

		// method returns, somewhere else returns a CompletionMessage with any errors
		return sb.ToString();
	}
}
```

## Streaming *to* and *from* the server

After using `GetDownStreamController` to stream results from the server and `GetUpStreamController` to stream parameters to the server, there's a third one to merge these two's functionality, the `GetUpAndDownStreamController` function. With its help we can stream parameters to a server-side function just like with `GetUpStreamController` and stream down its result to the client like we can with `GetDownStreamController`.
Here's an example usage:
```language-csharp
using (var controller = hub.GetUpAndDownStreamController<string, string>("StreamEcho"))
{
	controller.OnSuccess(_ =>
	{
		Debug.log("Finished!");
	});

	controller.OnItem(item =>
	{
		Debug.log("On Item: " + item);
	});

	const int numMessages = 5;
	for (int i = 0; i < numMessages; i++)
	{
		yield return new WaitForSeconds(_yieldWaitTime);

		controller.UploadParam(string.Format("Message from client {0}/{1}", i + 1, numMessages));
	}

	yield return new WaitForSeconds(_yieldWaitTime);
}
```

`GetUpAndDownStreamController` also returns with an `UpStreamItemController` instance, but in this case its `OnItem` can be used too. The callback passed to the `OnItem` call will be called for every item the server sends back to the client.

Related server code:
```language-csharp
public class UploadHub : Hub
{
	public ChannelReader<string> StreamEcho(ChannelReader<string> source)
	{
		var output = Channel.CreateUnbounded<string>();

		_ = Task.Run(async () =>
		{
			while (await source.WaitToReadAsync())
			{
				while (source.TryRead(out var item))
				{
					Debug.WriteLine($"Echoing '{item}'.");
					await output.Writer.WriteAsync("echo:" + item);
				}
			}
			output.Writer.Complete();

		});

		return output.Reader;
	}
}
```

## Send non-streaming parameter

`GetUpStreamController` and `GetUpAndDownStreamController` can send non-streaming parameters with theirs initial requests.

An example of sending multiple non-streaming and a streaming parameter:
```language-csharp
public enum MyEnum
{
    None,
    One,
    Two
}
public sealed class Metadata
{
    public string strData;
    public int intData;
    public MyEnum myEnum;
}

using (var controller = hub.GetUpStreamController<int, Person>("MixedArgsTest", /*int: */ 1, /*string: */ "text test", new Metadata() { strData = "string data", intData = 5, myEnum = MyEnum.One }))
{
    const int numMessages = 5;
    for (int i = 0; i < numMessages; i++)
    {
        Person person = new Person()
        {
            Name = "Mr. Smith",
            Age = 20 + i * 2
        };

        controller.UploadParam(person);
    }
}
```

Server code:
```language-csharp
public enum MyEnum
{
    None,
    One,
    Two
}

public sealed class Metadata
{
    public string strData;
    public int intData;
    public MyEnum myEnum;
}

public async Task<int> MixedArgsTest(ChannelReader<Person> source, int intParam, string stringParam, Metadata metadata)
{
    int count = 0;
    while (await source.WaitToReadAsync())
    {
        while (source.TryRead(out var item))
        {
            count++;
        }
    }

    return count;
}
```