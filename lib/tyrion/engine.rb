require "rails/engine"
require "tyrion"

class Tyrion::Engine < ::Rails::Engine #:nodoc:
  config.tyrion = Tyrion

  initializer "tyrion.configure_engine" do |app|
    app.config.middleware.use "Tyrion::TyrionRedirectMiddleware"

    ActiveSupport.on_load :action_view do
      include Tyrion::TyrionHelper
    end

  end
end
