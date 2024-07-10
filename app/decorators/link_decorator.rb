class LinkDecorator < SimpleDelegator
  include Rails.application.routes.url_helpers

  def short_url_full
    return "#{Rails.configuration.application_host}/#{__getobj__.short_url}" unless Rails.env.local?

    "http://#{Rails.configuration.application_host}/#{__getobj__.short_url}"
  end

  def daily_click_count(days_ago)
    __getobj__.visits.where('timestamp >= ?', days_ago)
                     .group_by_day(:timestamp)
                     .count
  end

  def click_count_by_country
    __getobj__.visits.group("geolocation->>'country'").count.map do |country, visits|
      { country: country, visits: visits }
    end
  end
end
