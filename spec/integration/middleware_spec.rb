require 'spec_helper'

describe TyrionRedirectMiddleware do

  let(:long_url) { "http://www.gameofthrones.com/lannister?vassels=2323" }
  let(:short_url) { Tyrion::ShortenedUrl.generate!(long_url, expires_at) }

  context "unexpired link" do
    let(:expires_at) { nil }

    it "should redirect" do
      s = short_url
      get "/s/#{s.unique_key}"
      s.reload
      response.status.should == 301
      response.location.should == long_url
      s.use_count.should == 1
    end

  end

  context "expired link" do
    let(:expires_at) { Time.zone.now - 1.week }

    it "should not redirect" do
      expect {get "/s/#{short_url.unique_key}"}.to raise_error(ActionController::RoutingError)
    end

  end

end