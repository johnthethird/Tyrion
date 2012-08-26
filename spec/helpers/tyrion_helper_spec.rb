# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tyrion::TyrionHelper do
  before { @short_url = Tyrion::ShortenedUrl.generate("www.doorkeeperhq.com") }

  describe "short_url" do
    it "should shorten the url" do
      helper.short_url("www.doorkeeperhq.com").should == "http://test.host/s/#{@short_url.unique_key}"
    end
  end
end
