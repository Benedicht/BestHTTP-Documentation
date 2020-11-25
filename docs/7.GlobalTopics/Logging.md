# Logging
To be able to dump out some important information about the plugin, it has its own logging mechanism.

The default logger can be accessed through the `HTTPManager.Logger` property. The default loglevel is `Warning` for *debug builds* and `Error` for others. This implementation uses Unity’s `Debug.Log`/`LogWarning`/`LogError` functions.

A new logger can be written by implementing the `ILogger` interface from the `BestHTTP.Logger` namespace.

The plugin, to minimise latency added by logging, uses a new threaded logger. As its name suggests, the actual logging happens on a separate thread.

## Changing verbosity 

It can be done by setting the logger's LogLevel:

```language-csharp
using BestHTTP;

HTTPManager.Logger.Level = Logger.Loglevels.All;
```

Setting the log level to `Loglevels.All` can be handful when you tring to find bugs or want to send over for inspection. Unity log file locations are listed here: [LogFiles](https://docs.unity3d.com/Manual/LogFiles.html).

## ILogOutput and the default UnityOutput implementation

All `ILogger` implementation has an `Output` field so writing logs to a file instead of the Unity Console requires a new output instead of a new `ILogger` implementation.

The `ILogOutput` interface is very slim:
```language-csharp
public interface ILogOutput : IDisposable
{
    void Write(Loglevels level, string logEntry);
}
```

And the default implementation is small too:
```language-csharp
using System;

namespace BestHTTP.Logger
{
    public sealed class UnityOutput : ILogOutput
    {
        public void Write(Loglevels level, string logEntry)
        {
            switch (level)
            {
                case Loglevels.All:
                case Loglevels.Information:
                    UnityEngine.Debug.Log(logEntry);
                    break;

                case Loglevels.Warning:
                    UnityEngine.Debug.LogWarning(logEntry);
                    break;

                case Loglevels.Error:
                case Loglevels.Exception:
                    UnityEngine.Debug.LogError(logEntry);
                    break;
            }
        }

        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
    }
}
```

## Logging into a file

In this case, there's no need to make different cases based on the level of the log entries, so Write only going to convert the string into a byte[] and tries to write it to the stream:

```language-csharp
using System;

using BestHTTP.Extensions;
using BestHTTP.PlatformSupport.Memory;

namespace BestHTTP.Logger
{
    public sealed class FileOutput : ILogOutput
    {
        private System.IO.Stream fileStream;

        public FileOutput(string fileName)
        {
            this.fileStream = HTTPManager.IOService.CreateFileStream(fileName, PlatformSupport.FileSystem.FileStreamModes.Create);
        }

        public void Write(Loglevels level, string logEntry)
        {
            if (this.fileStream != null && !string.IsNullOrEmpty(logEntry))
            {
                int count = System.Text.Encoding.UTF8.GetByteCount(logEntry);
                var buffer = BufferPool.Get(count, true);

                try
                {
                    System.Text.Encoding.UTF8.GetBytes(logEntry, 0, logEntry.Length, buffer, 0);

                    this.fileStream.Write(buffer, 0, count);
                    this.fileStream.WriteLine();
                }
                finally
                {
                    BufferPool.Release(buffer);
                }

                this.fileStream.Flush();
            }
        }

        public void Dispose()
        {
            if (this.fileStream != null)
            {
                this.fileStream.Close();
                this.fileStream = null;
            }

            GC.SuppressFinalize(this);
        }
    }
}
```

And setting the new output for the logger can be done like this:
```language-csharp
HTTPManager.Logger.Output = new FileOutput("besthttp.log");
```

## LoggingContext

To help indentify and track protocols, they have a `LoggingContext` instance that gets passed to the logger. Because a high level protocol usually uses other protocol(s), the hight level protocol adds own logging context to the lower one and going to get logged too.