---
title: Changelog
sidebar: best_http2_main_sidebar
---

## 1.2.0 (2022-11-16)

Minimum required Best HTTP/2 version is v2.8.0!

**General**
- [<span style="color:red">Bugfix</span>] [[Issue-129](https://github.com/Benedicht/BestHTTP-Issues/issues/129)] Removed calling of slow test method
- [<span style="color:red">Bugfix</span>] [[Issue-129](https://github.com/Benedicht/BestHTTP-Issues/issues/129)] Rewrote slow code to get the addon's folder with [CompilationPipeline.GetAssemblyDefinitionFilePathFromAssemblyName](https://docs.unity3d.com/ScriptReference/Compilation.CompilationPipeline.html)

## 1.1.1 (2022-08-26)

**General**
- [<span style="color:blue">Improvement</span>] Updated root and intermediate certificates
- [<span style="color:red">Bugfix</span>] Fixed compile error when BESTHTTP_DISABLE_CACHING was in use.

## 1.1.0 (2022-03-03)

**General**

- [<span style="color:green">New Feature</span>] v1.1.0 requires [Best HTTP/2 v2.6.0](https://assetstore.unity.com/packages/tools/network/best-http-2-155981?aid=1101lfX8E) or newer
- [<span style="color:green">New Feature</span>] Support for TLS 1.3
- [<span style="color:green">New Feature</span>] Added Server Initiated Renegotiation support
- [<span style="color:blue">Improvement</span>] Updated root and intermediate certificates
- [<span style="color:red">Bugfix</span>] Rewrote certificate load in the editor as it's caches old certificates, loading/adding new didn't show up

## 1.0.1 (2021-10-18)

**General**

- [<span style="color:red">Bugfix</span>] Fixed blocking password popup when requested for client certificate
- [<span style="color:blue">Improvement</span>] Updated help urls
- [<span style="color:blue">Improvement</span>] Fresh trusted root and intermediates

## 1.0.0 (2020-12-21)

Initial release