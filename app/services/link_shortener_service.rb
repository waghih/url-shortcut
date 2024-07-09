class LinkShortenerService
  def initialize(original_url, title = nil)
    @original_url = original_url
    @title = title
  end

  def build_short_url
    link = Link.new(original_url: @original_url)
    link.short_url = generate_unique_short_url
    link.title = @title.presence || fetch_title_from_url(@original_url)
    link
  end

  def fetch_title
    fetch_title_from_url(@original_url)
  end

  private

  def generate_unique_short_url
    loop do
      short_url = SecureRandom.alphanumeric(6)
      break short_url unless Link.exists?(short_url: short_url)
    end
  end

  def fetch_title_from_url(url)
    response = HTTParty.get(url)
    document = Nokogiri::HTML(response.body)
    document.title
  rescue StandardError
    'No Title'
  end
end
