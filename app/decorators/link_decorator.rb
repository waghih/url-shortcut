class LinkDecorator < SimpleDelegator
  include Rails.application.routes.url_helpers

  def short_url_full
    return "#{Rails.configuration.application_host}/#{__getobj__.short_url}" unless Rails.env.local?

    "http://#{Rails.configuration.application_host}/#{__getobj__.short_url}"
  end
end
