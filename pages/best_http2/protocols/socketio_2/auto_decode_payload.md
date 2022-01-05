---
title: AutoDecodePayload
sidebar: best_http2_main_sidebar
---

Already talked about AutoDecodePayload in *"Receiving binary data"*, however you can set this value not just per-event, but per-socket too. The socket has an AutoDecodePayload property that used as the default value of event subscription. Its default value is true - all payload decoded and dispatched to the event subscriber. If you set to false no decoding will be done by the plugin, you will have to do it by yourself.

**You don’t want to cast the args every time**: Sure! You can set the `AutoDecodePayload` on the Socket object, and you can use your favorite Json parser to decode the Packet’s Payload to a strongly typed object. However keep in mind that the payload will contain the event’s name and it’s a json array. A sample payload would look like this: `[‘eventName’, {‘field’: ‘stringValue’}, {‘field’: 1.0}]`.

