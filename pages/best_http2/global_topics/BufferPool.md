---
title: Buffer Pool
sidebar: best_http2_main_sidebar
---

To reduce memory garbage production the plugin reuses as much memory as it can. To support this, the plugin implements and uses a byte array pooling mechanism through the `BufferPool` static class. The plugin uses this class to allocate and release `byte[]`s back to the pool. 

To avoid keeping reference to too much memory the plugin requests buffers with a minimum size. This way if the `BufferPool` has no buffer for the requested size, it can return a larger buffer. Also, buffers stored in the pool can time out, releasing back to the runtime for garbage collection.

## Options

Pooling mechanism can be disabled, configured and used by outside of the plugin. Configurable fields are the following:

- **IsEnabled**: Setting this field to false the pooling mechanism can be disabled. Its default value is `true`.
- **RemoveOlderThan**: Buffer entries that released back to the pool and older than this value are removed from the pool (so the GC can collect them) when next maintenance is triggered. Its default value is 30 seconds.
- **RunMaintenanceEvery**: How often pool maintenance must run. Its default value is 10 seconds.
- **MinBufferSize**: Minimum buffer size that the plugin will allocate when the requested size is smaller than this value, and canBeLarger is set to true. Its default value 256 bytes.
- **MaxBufferSize**: Maximum size of a buffer that the plugin will store. Its default value is `long.MaxValue`.
- **MaxPoolSize**: Maximum accumulated size of the stored buffers. Its default value is 10 Mb.
- **RemoveEmptyLists**: Whether to remove empty buffer stores from the free list. Its default value is `true`.
- **IsDoubleReleaseCheckEnabled**: If it set to true and a byte[] is released more than once it will log out an error. Its default value is `true` when run in the editor, `false` otherwise.

So to disable pooling the following line can be added:
```csharp
BestHTTP.PlatformSupport.Memory.BufferPool.IsEnabled = false;
```

The following functions are available to use the pool:

- **byte[] Get(long size, bool canBeLarger)**: Get a byte array from the pool. If `canBeLarge` is `true`, the returned buffer might be larger than the requested size.
- **void Release(byte[] buffer)**: Release back a byte array to the pool.
- **byte[] Resize(ref byte[] buffer, int newSize, bool canBeLarger)**: Resize a byte array. It will release the old one to the pool and get a new one from the pool.
- **void Clear()**: Remove all stored entries instantly.