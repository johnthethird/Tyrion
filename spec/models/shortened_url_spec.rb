# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tyrion::ShortenedUrl do
  it { should validate_presence_of :url }

  shared_examples_for "shortened url" do
    let(:short_url) { Tyrion::ShortenedUrl.generate!(long_url, expires_at) }
    it "should be shortened" do
      short_url.should_not be_nil
      short_url.url.should == expected_long_url
      short_url.unique_key.length.should == 5
      short_url.expires_at.should == expires_at
    end
  end

  context "shortened url" do
    let(:long_url) { "http://www.doorkeeperhq.com/" }
    let(:expected_long_url) { long_url }
    let(:expires_at) { nil }
    it_should_behave_like "shortened url"
  end

  context "shortened url with partial URL" do
    let(:long_url) { "www.doorkeeperhq.com" }
    let(:expected_long_url) { "http://www.doorkeeperhq.com/" }
    let(:expires_at) { nil }
    it_should_behave_like "shortened url"
  end

  context "shortened url with i18n path" do
    let(:long_url) { "http://www.doorkeeper.jp/%E6%97%A5%E6%9C%AC%E8%AA%9E" }
    let(:expected_long_url) { long_url }
    let(:expires_at) { nil }
    it_should_behave_like "shortened url"
  end

  context "unexpired url" do
    let(:long_url) { "www.doorkeeperhq.com" }
    let(:expected_long_url) { "http://www.doorkeeperhq.com/" }
    let(:expires_at) { Time.now + 1.week }
    it_should_behave_like "shortened url"
  end

  context "expired url" do
    let(:long_url) { "www.doorkeeperhq.com" }
    let(:expected_long_url) { "http://www.doorkeeperhq.com/" }
    let(:expires_at) { Time.now - 1.week }
    it_should_behave_like "shortened url"
  end

  context "expires_at scope" do
    before {
      @expired_url   = Tyrion::ShortenedUrl.generate!("http://www.doorkeeperhq.com/expired", Time.zone.now - 1.week)
      @unexpired_url = Tyrion::ShortenedUrl.generate!("http://www.doorkeeperhq.com/unexpired", Time.zone.now + 1.week)
    }
    it "not find expired url via scope" do
      Tyrion::ShortenedUrl.find_for_redirect(@expired_url.unique_key).should be_nil
    end
    it "find unexpired url via scope" do
      Tyrion::ShortenedUrl.find_for_redirect(@unexpired_url.unique_key).should == @unexpired_url
    end
  end

  context "existing shortened URL" do
    before { @existing = Tyrion::ShortenedUrl.generate!("http://www.doorkeeperhq.com/") }
    it "should look up existing URL" do
      Tyrion::ShortenedUrl.generate!("http://www.doorkeeperhq.com/").should == @existing
      Tyrion::ShortenedUrl.generate!("www.doorkeeperhq.com").should == @existing
    end
    it "should generate different one for different" do
      Tyrion::ShortenedUrl.generate!("www.doorkeeper.jp").should_not == @existing
    end

    context "duplicate unique key" do
      before do
        Tyrion::ShortenedUrl.any_instance.stub(:generate_unique_key).
          and_return(@existing.unique_key, "ABCDEF")
      end
      it "should try until it finds a non-dup key" do
        short_url = Tyrion::ShortenedUrl.generate!("client.doorkeeper.jp")
        short_url.should_not be_nil
        short_url.unique_key.should == "ABCDEF"
      end
    end
  end
end
