class Tyrion::ShortenedUrl < ActiveRecord::Base

  URL_PROTOCOL_HTTP = "http://"
  REGEX_LINK_HAS_PROTOCOL = Regexp.new('\Ahttp:\/\/|\Ahttps:\/\/', Regexp::IGNORECASE)

  validates :url, :presence => true

  def self.find_for_redirect(unique_key)
    where("unique_key = ? AND (expires_at is null or expires_at > ?)", unique_key, Time.zone.now).first
  end

  # ensure the url starts with a protocol and is normalized
  def self.clean_url(url)
    return nil if url.blank?
    url = URL_PROTOCOL_HTTP + url.strip unless url =~ REGEX_LINK_HAS_PROTOCOL
    URI.parse(url).normalize.to_s
  end

  # generate a shortened link from a url
  # throw an exception if anything goes wrong
  def self.generate!(orig_url, expires_at=nil)
    # don't want to generate the link if it has already been generated
    # so check the datastore. If it has been generated, return the same
    # link but with new expiration date
    cleaned_url = clean_url(orig_url)
    shortened_url = self.find_or_create_by_url(cleaned_url)
    shortened_url.expires_at = expires_at
    shortened_url.save
    shortened_url
  end

  # The default is to simply increment the use_count, but feel free to use the info in the request and go nuts
  def track!(request=nil)
    increment!(:use_count)
  end

  # return shortened url on success, nil on failure
  def self.generate(orig_url, owner=nil)
    begin
      generate!(orig_url, owner)
    rescue
      nil
    end
  end

  private

  # we'll rely on the DB to make sure the unique key is really unique.
  # if it isn't unique, the unique index will catch this and raise an error
  def create
    count = 0
    begin
      self.unique_key = generate_unique_key
      super
    rescue ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid => err
      if (count += 1) < 5
        logger.info("[Tyrion] retrying with different unique key")
        retry
      else
        logger.info("[Tyrion] too many retries, giving up")
        raise
      end
    end
  end

  # generate a random string
  def generate_unique_key
    # not doing uppercase as url is case insensitive
    charset = ::Tyrion.key_chars
    (0...::Tyrion.unique_key_length).map{ charset[rand(charset.size)] }.join
  end

end
