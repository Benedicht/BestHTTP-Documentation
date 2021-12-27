---
title: Quality of Service Levels
sidebar: best_mqtt_sidebar
---

A QoS level is an agreement between a sender and a receiver about the delivery guarantees of application messages.

## AtMostOnceDelivery (QoS 0)

With QoS 0 delivery of application messages are not guaranteed. The sender sends the application message, but no acknowledgement message is sent by the receiver whether it received it or not, hence no retry mechanism either.
This is the fastest but most unreliable QoS level.

## AtLeastOnceDelivery (QoS 1)

With QoS 1 the protocol guarantees that the receiver receives application messages at least once. 
This guarantee is achieved by listening for an acknowledgement message and if not received while the client is online, the sender resends the application message with the Dupplicate flag set to true when client next time goes online.

{% include warning.html content="Using QoS 1 the subscriber must be prepared that messages might received more than once!" %}

## ExactlyOnceDelivery (QoS 2)

With QoS 2 the protocol guarantees that the receiver receives application messages exactly once.
To achieve this reliability, MQTT v5 uses a four message handshake process that starts with the publishing of the application message. This is the most reliable but slowest QoS level.

## QoS Downgrade

Clients can subscribe to a topic with their own QoS level preference and it can be lower than clients sending application messages with.

{% include image.html file="media\QoS.drawio.png" %}

## Further reading

A very good article about QoS Levels (and many more) can be found on [HiveMQ's blog](https://www.hivemq.com/blog/mqtt-essentials-part-6-mqtt-quality-of-service-levels/).