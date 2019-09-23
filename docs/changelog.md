## Changelog

#2.0.0 (2019)
**This a major release breaking backward compatibility with older releases.**

#1.12.2 (2019.06.12)

<b>General</b>

* [<span style="color:blue">Improvement</span>] When the same content is already stored on the disk, new responses will no write it again saving cpu and disk activity
* [<span style="color:red">Bugfix</span>] Fixed compile errors for UWP
* [<span style="color:red">Bugfix</span>] Fixed a possible NullReferenceException when the server sends back no headers at all
* [<span style="color:red">Bugfix</span>] Read and store responses are in a write lock to avoid an error when two or more requests to the same uri are executed.
* [<span style="color:red">Bugfix</span>] When CookieJar.Get called before any other CookieJar.Load it throwd an error

#1.12.1 (2019.05.29)
<b>General</b>

* [<span style="color:red">Bugfix</span>] Callbacks didn't called when abort requested on a HTTPRequest
* [<span style="color:red">Bugfix</span>] ReaderWriterLockSlim of the HTTPRequest is nulled out while it later tried to use it

#1.12.0 (2019.05.28)
<b>General</b>

* [<span style="color:blue">Improvement</span>] Part of a larger code rewrite/overhaul removed a lot of locks and added lock-free collections and/or using ReaderWriterLockSlim. These changes affect all parts of the plugin from cookies to the signalr core protocol.
* [<span style="color:red">Bugfix</span>] Fixed a bug in the protocol upgrade callback to do not overwrite the connection's previously set state
* [<span style="color:green">New Feature</span>] HTTPRequest now supports the async-await pattern when CSHARP_7_OR_LATER is declared by Unity3d
* [<span style="color:blue">Improvement</span>] HTTPManager.TryToMinimizeTCPLatency's default value became true
* [<span style="color:blue">Improvement</span>] HTTPManager.MaxConnectionPerServer's default value became 6

<b>SignalRCore</b>

* [<span style="color:red">Bugfix</span>] JSonProtocol now handles enums properly
* [<span style="color:blue">Improvement</span>] JSonProtocol now can handle nullable types

<b>Server-Sent Events</b>

* [<span style="color:green">New Feature</span>] Example added