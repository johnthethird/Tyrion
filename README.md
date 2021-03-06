Tyrion
======

Yet Another URL Shortener implemented as a Rails Engine and some middleware. The Gem consists of three main parts:

* ShortenedUrl model to track links and their corresponding shortened urls.
* Rack Middleware to detect any requests for a short link and return an HTTP 301 redirect to the original link.
* A view helper to create shortened links.

Installation
============
You can use the latest Rails 3 gem with the latest Tyrion gem. In your Gemfile:

  ```ruby
  gem 'tyrion', :git => 'git://github.com/johnthethird/tyrion.git'
  ```

> Note: There is another Gem named Tyrion, so you have to install from Github.  Yes, the other Gem has been around longer, but come on, this has got to be the best name ever for a URL shortener, right? So I'm standing my ground. :)


Use bundler to install the Gem:

  ```ruby
  bundle install
  ```

Then run the generator:

  ```ruby
  rails generate tyrion
  ```

This generator will create a migration to create the shortened_urls table where your shortened URLs will be stored.

Finally, rub the migration scripts against your database:

  ```ruby
  rake db:migrate
  ```

Usage
=====

To generate a ShortenedUrl object for the URL "http://lannister.com?vassels=2323" within your controller / models do the following:

  ```ruby
  Tyrion::ShortenedUrl.generate("http://lannister.com?vassels=2323")
  ```

If you want your short urls to expire after a certain amount of time, you can add an expiration date. If a user clicks on an expired link they would receive an HTTP 404 Not Found error.

  ```ruby
  Tyrion::ShortenedUrl.generate("http://lannister.com?vassels=2323", Time.zone.now + 1.week)
  ```

To generate and display a shortened URL in your application use the helper method:

  ```ruby
  short_url("http://lannister.com?vassels=2323")
  ```

This will generate a shortened URL, store it in the db, and return a string representing the shortened URL. To specify an expiration date:

  ```ruby
  short_url("http://lannister.com?vassels=2323", Time.zone.now + 1.week)
  ```

By default, all short urls are routed through "/s/(unique_key)". If you want to change the "s" prefix to something else, you can do this in an initializer:

  ```ruby
  Tyrion.route_prefix = "z"
  Tyrion.route_regex = %r(\A\/z\/(\w*)\z)
  ```

Note that route_regex should have a single capture group specified that captures the unique_key.


Shorten URLs in generated emails
================================

You can register the included mail interceptor to shorten all links in the emails generated by your Rails app. For example, add to your mailer:

  ```ruby
  class MyMailer < ActionMailer::Base
    register_interceptor Tyrion::ShortenUrlInterceptor.new
  end
  ```

This will replace all long URLs in the emails generated by MyMailer with shortened versions. The base URL for the shortener will be infered from the mailer's default_url_options. If you use a different hostname for your shortener, you can use:

  ```ruby
  class MyMailer < ActionMailer::Base
    register_interceptor Tyrion::ShortenUrlInterceptor.new :base_url => "http://shortener.host"
  end
  ```

The interceptor supports a few more arguments, see the implementation for details.

Tracking Usage Metrics
======================

By default, Tyrion will track a use_count for each short url. Every time the Rack middleware redirects to a shortened url, the use_count is incremented. You can turn this off in an initializer like so:

  ```ruby
  Tyrion.track = false
  ```


Authors
=======

This Gem is based in large part on the Shortener Gem by [James McGrath](https://github.com/jpmcgrath) and [Michael Reinsch](https://github.com/mreinsch). I removed the ability to tie shortened urls to other models, as we didn't need the added complexity. I also converted the controller which handled the redirect to a Rack middleware instead.

Future goals for this Gem include leveraging the TorqueBox messaging queue to handle the tracking of url metrics, as well as other features which will also depend entirely on TorqueBox, so a whole new Gem instead of a fork seemed appropriate.



