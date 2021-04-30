---
title: Exploratory Data Analysis on Vtubers Live Chat
---

A little experiment and analysis on toxic people floating across YouTube.

# Why

The motivation is straightforward; I just feel sad when they suffered from random toxic chats. The goal is also straightforward: design an automated system spotting toxic chat and quarantine them.

# Data, Data, Data

> I can't make bricks without clay.  
> — Sherlock Holmes

I need a myriad of live chat comments and moderation events for the experiment.

Unfortunately, YouTube API does not offer a way to retrieve these kinds of events in real time, which is crucial because live streams are only place we can observe moderators' activities (deletion and BAN). Once it gets archived, these events are no longer available to fetch.

## Collecting Crusts

So, I ended up developing a library to accumulate events from a live stream, with a fancy CLI app mimics live chat. It accepts YouTube video id and save live chats in [JSON Lines](https://jsonlines.org/) format:

```bash
collector <videoId>
```

![](realtime-chat.gif)

A line with white text is a normal chat, red text is a ban event, and yellow text is a deletion event.

I know, that's not scalable at all. A new live stream comes in, I copy and paste video id into the terminal and run the script. How sophisticated.

## Make Bread Rise

Thankfully, there's a great web service around Hololive community: [Holotools](https://hololive.jetri.co). They operate an API that gives us an index of past, ongoing, and upcoming live streams from Hololive talents.

Here I divided my system into two components: Scheduler and workers. Scheduler periodically checks for newly scheduled live streams through Holotools API and create a job to be handled by workers. Workers are responsible for handling jobs and spawning a process to collect live chat events.

At this point, saving chat to text files in JSONL format is just ineffective as the throughput grows tremendously, I've managed to switch its data source to MongoDB.

![](scalability.png)

I run the cluster for a while, and by far it hoards approximately one million comments per day. Now I could reliably run my own bakery.

# Look Before You Leap

Okay now there are five million chats sitting on MongoDB store. Let's take a close look at these before actually starting to build a model.

## Troll's Behavior

## By talent

## By language

# Creating Dataset

## Labelling Toxic Chat

### Utilizing Moderators' Activities

### Browser Extension

### Normalized Co-occurrence Entropy

Shannon Entropy is not enough. So I combined the ideas of [Burrows-Wheeler Transform](https://en.wikipedia.org/wiki/Burrows%E2%80%93Wheeler_transform) and [Run-length Encoding](https://en.wikipedia.org/wiki/Run-length_encoding) to formulate a new entropy which represents "spamminess" of given text.

$$
NCE(T) = \frac{N_T}{RLE_{string}(BWT(T))}
$$

$$
BWT[T,i] = \begin{cases} T[SA[i]-1], & \text{if }SA[i] > 0\\ \$, & \text{otherwise}\end{cases}
$$

### Sentence Encoding

Here's a [t-SNE](https://en.wikipedia.org/wiki/T-distributed_stochastic_neighbor_embedding) visualization for output of Sentence Transformer. Blue dots are spam and orange dots are normal chats.

![](tsne-sentence-encoding.png)

# Learn

## Gradient Boosting

## Neural Networks

# Future

When it's ready, I'm going to publish a dataset and pre-trained model used in this experiment.
