# frozen_string_literal: true

module ApplicationHelper
  def country_name(code)
    ISO3166::Country[code]&.unofficial_names&.first || 'Unknown'
  end
end
