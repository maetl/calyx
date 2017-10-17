---
title: Installation
layout: docs
permalink: /guides/installation
---

## System requirements

The following prerequisites are needed to install Calyx:

- macOS, Windows, GNU/Linux or Unix
- Ruby 2.3 or above (MRI 2.3+, JRuby 9+, Rubinius 3+)
- RubyGems

Calyx has no external Gem dependencies.

## For command line use

Install the Calyx gem using the [RubyGems](https://rubygems.org) package manager:

```
gem install calyx
```

## For applications

Add the `calyx` dependency to your app’s `Gemfile`:

```ruby
gem 'calyx'
```

Run [Bundler](https://bundler.io/) to install it:

```
bundle install
```

## For local development

To contribute code back to Calyx or fork it in a new direction, clone the repo from GitHub:

```
git clone git@github.com:maetl/calyx
```

You can also download the latest build of the project as a ZIP archive:

```
wget https://github.com/maetl/calyx/archive/master.zip
```
