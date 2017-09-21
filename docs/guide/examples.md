# Examples

The best way to get started quickly is to install the gem and run the examples locally.

## Any Gradient

Requires Roda and Rack to be available.

```
gem install roda
```

Demonstrates how to use Calyx to construct SVG graphics. **Any Gradient** generates a rectangle with a linear gradient of random colours.

Run as a web server and preview the output in a browser (`http://localhost:9292`):

```
ruby examples/any_gradient.rb
```

Or generate SVG files via a command line pipe:

```
ruby examples/any_gradient > gradient1.xml
```

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

## Faker

[Faker](https://github.com/stympy/faker) is a popular library for generating fake names and associated sample data like internet addresses, company names and locations.

This example demonstrates how to use Calyx to reproduce the same functionality using custom lists defined in a YAML configuration file.

```
ruby examples/faker.rb
```
