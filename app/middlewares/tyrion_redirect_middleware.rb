class TyrionRedirectMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)

    if (env["PATH_INFO"] =~ ::Tyrion.route_regex) && (tyrion = ::Tyrion::ShortenedUrl.find_for_redirect($1))
      tyrion.track!(Rack::Request.new(env)) if ::Tyrion.track == true
      [301, {'Location' => tyrion.url}, []]
    else
      @app.call(env)
    end

  end
end
