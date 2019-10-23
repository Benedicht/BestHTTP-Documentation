# Logging
To be able to dump out some important information about the plugin, it has its own logging mechanism.

The default logger can be accessed through the HTTPManager.Logger property. The default loglevel is `Warning` for *debug builds* and `Error` for others. This implementation uses Unity’s `Debug.Log`/`LogWarning`/`LogError` functions.

A new logger can be written by implementing the ILogger interface from the BestHTTP.Logger namespace.

## Changing verbosity 

It can be done by setting the logger's LogLevel:

```language-csharp
using BestHTTP;

HTTPManager.Logger.Level = Logger.Loglevels.All;
```

Setting the log level to `All` can be handful when you tring to find bugs or want to send over for inspection. Unity log file locations are listed here: [LogFiles](https://docs.unity3d.com/Manual/LogFiles.html).