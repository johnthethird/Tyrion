module Tyrion::TyrionHelper

  # generate a url from a url string
  def short_url(url, expires_at=nil)
    short_url = Tyrion::ShortenedUrl.generate(url, expires_at)
    short_url ? "#{request.protocol}#{request.host_with_port}/#{Tyrion.route_prefix}/#{short_url.unique_key}" : url
  end

end
