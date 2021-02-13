---
title: Toxicity Analysis in Vtuber Live Chat
---

A little exploration and experiment on classifying toxic comments.

# Why

The motivation is simple; I just feel sad when they look suffered from toxic comments in live chats. The goal is also simple: design an automated system to spot toxic comments and destroy them.

# Data Data Data

> I can't make bricks without clay.
> — Sherlock Holmes

I need a myriad of live chat comments and moderation events for analysis and future use.

Unfortunately, YouTube API does not offer a way to retrieve these kind of events in real time. Which is so crucial because live streams are only place we can observe moderators' activities through API response. Once it gets archived, these events are no longer available.

## Collecting Crusts

So, I ended up developing a library to accumulate events from a YouTube live stream, plus a fancy CLI app mimics live chat. It accepts YouTube video id and save live chats in [JSON Lines](https://jsonlines.org/) format:

```bash
collector <videoId>
```

![](realtime-chat.gif)

A line with white text is a normal chat, with red text is a ban event, with yellow text is a deletion event.

## Make the Bread Rise

I know, that's not scalable at all. A new live stream comes in, I copy and paste video id into the terminal and run the script. How sophisticated.

Thankfully, there's a fantastic service around Hololive community: [Holotools](https://hololive.jetri.co). They operates an API that gives us past, ongoing, and upcoming live streams from Hololive talents.

Here I divided my system into two components: watch tower and collection worker. Watch tower periodically checks for newly scheduled live streams through Holotools API and create a job to be handled by workers. Collection workers are responsible for handling jobs and spawning a process to collect live chat events.

![](scalability.png)

I run the cluster for a while and by far it collects approximately 1 million comments per day. Now I could reliably run my own bakery.

# Look Before You Leap

Okay take a close look at the data before actually starting to build a model.

## Overview

## By talent

## By language

# Making Dataset

## Labelling Spam & Toxic Chat

### Utilizing Moderators' Activities

### Introducing Balanced Collocation Entropy

$$
BCE(T) = \frac{N_T}{RLE_{string}(BWT(T))}
$$

$$
BWT[T,i] = \begin{cases} T[SA[i]-1], & \text{if }SA[i] > 0\\ \$, & \text{otherwise}\end{cases}
$$

Shannon Entropy is not enough. So I decided to combine the ideas of [Burrows-Wheeler Transform](https://en.wikipedia.org/wiki/Burrows%E2%80%93Wheeler_transform) and [Run-length Encoding](https://en.wikipedia.org/wiki/Run-length_encoding) and create a new entropy which represents "spamness" better than Shannon entropy does.

### Browser Extension

## Sentence Encoding

Here's a [t-SNE](https://en.wikipedia.org/wiki/T-distributed_stochastic_neighbor_embedding) visualization for output of Sentence Transformer. Blue dots are spam and orange dots are normal chats.

![](tsne-sentence-encoding.png)

# Learn

## Gradient Boosting

## Neural Networks

# Future

# Omake

## Hololive Dataset

I made collected chat events publicly available for those interested in further research.

The dataset contains:

- Chats
- Superchats (amount, currency)
- Retraction events
- Moderation events (ban, delete)

## Toxicity Estimator Pre-trained Model
