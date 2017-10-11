---
layout: default
title: Examples
layout: page
permalink: /examples/tiny-woodland-bot
---

## Tiny Woodland Bot

Requires the Twitter client gem and API access configured for a specific Twitter handle.

```
gem install twitter
```

Demonstrates how to use Calyx to make a minimal Twitter bot that periodically posts unique tweets. See [@tiny_woodland on Twitter](https://twitter.com/tiny_woodland) and the [writeup here](http://maetl.net/notes/storyboard/tiny-woodlands).

```
TWITTER_CONSUMER_KEY=XXX-XXX
TWITTER_CONSUMER_SECRET=XXX-XXX
TWITTER_ACCESS_TOKEN=XXX-XXX
TWITTER_CONSUMER_SECRET=XXX-XXX
ruby examples/tiny_woodland_bot.rb
```
