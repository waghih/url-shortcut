class UrlShortenerService
  def initialize(original_url)
    @original_url = original_url
  end

  def generate_short_url
    web_address = WebAddress.new(original_url: @original_url)
    web_address.short_url = generate_unique_short_url
    web_address.title = fetch_title(@original_url)
    web_address.save
    web_address
  end

  private

  def generate_unique_short_url
    loop do
      short_url = SecureRandom.alphanumeric(6)
      break short_url unless WebAddress.exists?(short_url: short_url)
    end
  end

  def fetch_title(url)
    uri = URI.parse(url)
    response = Net::HTTP.get(uri)
    response.match(/<title>(.*?)<\/title>/i)[1]
  rescue
    "No Title"
  end
end