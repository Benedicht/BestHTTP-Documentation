---
title: Topic Names & Filters
sidebar: best_mqtt_sidebar
---

## Topic Names

A topic name is an UTF-8 string containing one or more levels separated by a forward slash character (`/`). A topic name must not contain any wildcard characters (`+` and `#`)! Topic names are usabe both in publish and subscribe operations.

Example topic names:

| Topic Name |
|------------|
| `topic` |
| `topic name` |
| `multi/level/topic` |
| `multi/level/topic/` |
| `/multi/level/topic/` |
| `/` |

{% include note.html content="Topic matching is case sensitive, **TOPIC** and **topic** are two different topic names!" %}

## Topic Filters

Wildcard characters can be used in topic filters to match one or more levels within a topic. MQTT has two types of wildcard characters a Single-level wildcard (`+`) and a Multi-level wildcard (`#`).

### Single-level wildcard

A single-level wildcard can be used to match one level and multiple single-level wildcards can be used in one topic filter. 

| Topic Filter | Matching topics | Non-matching topics |
|-|-|-|
| `+` | `finance` | |
| `/+` | `/finance` | |
| `+/+` | `/finance` | |
| `sport/+` | `sport/` | `sport` |
| `sport/tennis/+` | `sport/tennis/player1` | `sport/tennis/player1/ranking` |
| | `sport/tennis/player2` | |

{% include warning.html content="**sport+** is not a valid topic filter because it must be used to match a whole level!" %}

### Multi-level wildcard

A multi-level wildcard (`#`) can be used to match any level in a topic name. `#` matches its parent level and any number of child levels. When `#` is used it must be the last character of the topic filter.

| Topic Filter | Matching topics |
|-|-|
| `sport/#` | `sport` |
| `sport/tennis/player1/#` | `sport/tennis/player1` |
| | `sport/tennis/player1/` |
| | `sport/tennis/player1/ranking` |
| | `sport/tennis/player1/score/wimbledon` |

### Mixed topic filters

Single and multi level wildcards can be used in one topic filter:

| Topic Filter | Matching topics |
|-|-|
| `+/tennis/#` | `sport/tennis/player1/ranking` |