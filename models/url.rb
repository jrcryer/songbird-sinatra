class URL
  include MongoMapper::Document

  key :url_key, String, :required => true
  key :full_url, String, :required => true
  
  validates_format_of :full_url, :with => URI::regexp(%w(http https))

  def self.find_or_create(new_url)
    url_key = Digest::MD5.hexdigest(new_url)[0..4]
    begin
      # Check if the key exists, so we don't have to create the URL again.
      url = self.find_by_url_key(url_key)
      if url.nil?
        url = URL.new(:url_key => url_key, :full_url => new_url)
        url.save!
      end
      return url
    rescue MongoMapper::DocumentNotValid
    end
  end
end