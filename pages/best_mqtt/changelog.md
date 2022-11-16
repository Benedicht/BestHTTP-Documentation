---
title: Changelog
sidebar: best_mqtt_sidebar
---

## 1.2.0 (2022-11-16)

Minimum required Best HTTP/2 version is v2.8.0!

- [<span style="color:blue">Improvement</span>] Use [WebSocket's SendAsBinary](../best_http2/protocols/websocket/websocket.html#sendasbinarybuffersegment-data) introduced in [Best HTTP/2 v2.8.0](../best_http2/changelog.html).
- [<span style="color:red">Bugfix</span>] Disable proxy usage under WebGL

## 1.1.1 (2022-08-26)

- [<span style="color:blue">Improvement</span>] `ConnectPacketBuilder`: If not already added, set default `TopicAlias Maximum` to `ushort.MaxValue`.
- [<span style="color:blue">Improvement</span>] Call error and disconnect event handler after `OnServerConnectAckMessage` if `ReasonString` contains an error.
- [<span style="color:red">Bugfix</span>] Fixed compile error when BESTHTTP_DISABLE_PROXY is defined.
- [<span style="color:red">Bugfix</span>] Made `ApplicationMessage`'s `TopicAlias` and `WithTopicName` internal.
- [<span style="color:red">Bugfix</span>] Made `BulkUnsubscribePacketBuilder`'s `UnsubscribePacketBuilder` and `BulkUnsubscribePacketBuilder` internal.
- [<span style="color:red">Bugfix</span>] `LastWillBuilder` will not try to set payload format indicator.


## 1.1.0 (2022-03-30)

- [<span style="color:green">New Feature</span>] Added MQTT v3.1.1 support. [Documentation about how to switch between versions](other/mqtt_versions.html).

## 1.0.0 (2022-01-04)

Initial Release