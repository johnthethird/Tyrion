require "active_support/dependencies"

module Tyrion

  autoload :ShortenUrlInterceptor, "tyrion/shorten_url_interceptor"

  CHARSETS = {
    :alphanum => ('a'..'z').to_a + (0..9).to_a,
    :alphanumcase => ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a }

  # default key length: 5 characters
  mattr_accessor :unique_key_length
  self.unique_key_length = 5

  # character set to chose from:
  #  :alphanum     - a-z0-9     -  has about 60 million possible combos
  #  :alphanumcase - a-zA-Z0-9  -  has about 900 million possible combos
  mattr_accessor :charset
  self.charset = :alphanumcase

  # Record each use in db
  mattr_accessor :track
  self.track = true

  # The prefix used to create and detect short urls. Defaults to "s" for urls like "/s/dEwsa"
  mattr_accessor :route_prefix
  self.route_prefix = "s"

  # The middleware uses this regex to detect short urls. The first capture group should be the unique_key.
  mattr_accessor :route_regex
  self.route_regex = %r(\A\/#{route_prefix}\/(\w*)\z)

  def self.key_chars
    CHARSETS[charset]
  end
end

require "tyrion/engine"
