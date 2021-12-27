---
title: File System Abstraction
sidebar: best_http2_main_sidebar
---

The plugin supports numerous platforms with different File System APIs or no file system access at all. To make the development of the plugin easier, the plugin uses an abstraction of the file system through an `BestHTTP.PlatformSupport.FileSystem.IOService` interface. There are different implementations for systems that requires it.

## Disable File System Accesses

To disable file system access a new `IOService` implementation can be created:

```csharp
public sealed class NullIOService : BestHTTP.PlatformSupport.FileSystem.IIOService
{
    public Stream CreateFileStream(string path, FileStreamModes mode)
    {
        throw new NotImplementedException();
    }

    public void DirectoryCreate(string path)
    {
        throw new NotImplementedException();
    }

    public bool DirectoryExists(string path)
    {
        throw new NotImplementedException();
    }

    public void FileDelete(string path)
    {
        throw new NotImplementedException();
    }

    public bool FileExists(string path)
    {
        throw new NotImplementedException();
    }

    public string[] GetFiles(string path)
    {
        throw new NotImplementedException();
    }
}
```

And then set it through the `HTTPManager` before using the plugin:
```csharp
BestHTTP.HTTPManager.IOService = new NullIOService();
```

Cookie Jar, caching service, etc. uses `DirectoryExists` or `FileExists` first and if these functions are throwing an exception that service is going to be disabled and no further attempt are made to try accessing the file system.

## Setting a custom cache folder path

With default settings all cached content, cookies, etc. are saved under the directory returned by `UnityEngine.Application.persistentDataPath`.
A new, custom path can be returned by setting a function that returns a string for `HTTPManager.RootCacheFolderProvider`:

```csharp
BestHTTP.HTTPManager.RootCacheFolderProvider = () => "my\custom\path\";
```

In most cases the path returned by `UnityEngine.Application.persistentDataPath` is just fine, but in some special cases it can be handy to be able to define a new one.

## Nintendo Switch

While i can't test the plugin on Nintendo's Switch platform, i'm getting reports that it works fine under it, although the default `IOService` implementation can cause some trouble. For a quick workaround the `RootCacheFolderProvider` can be set to do not try to access `UnityEngine.Application.persistentDataPath` and an IIOService that doesn't try to access the file system (like the `NullIOService` implementation above). As a further improvement a new `IOService` can be made using Nintendo's APIs to fully support the required functions.