class LinkDecorator < SimpleDelegator
  include Rails.application.routes.url_helpers

  def short_url_full
    "#{Rails.configuration.application_host}/#{__getobj__.short_url}"
  end
end