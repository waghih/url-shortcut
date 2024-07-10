# frozen_string_literal: true

module ApplicationHelper
  def country_name(code)
    ISO3166::Country[code]&.iso_long_name || 'Unknown'
  end
end
