class LinkShortenerService
  def initialize(original_url)
    @original_url = original_url
  end

  def build_short_url
    web_address = Link.new(original_url: @original_url)
    web_address.short_url = generate_unique_short_url
    web_address.title = fetch_title(@original_url)
    web_address
  end

  private

  def generate_unique_short_url
    loop do
      short_url = SecureRandom.alphanumeric(6)
      break short_url unless Link.exists?(short_url: short_url)
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