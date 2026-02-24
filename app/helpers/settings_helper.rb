# frozen_string_literal: true

module SettingsHelper
  # Get the value of a setting by key for the current organization.
  # Returns the setting value or the default if not found.
  # Uses memoized hash for O(1) lookup after first call.
  #
  # @param key [String] The setting key to look up
  # @param default [Object] The default value if setting not found (default: nil)
  # @return [String, nil] The setting value or default
  def get_setting_value(key, default = nil)
    return default unless @settings_by_category

    @settings_hash ||= @settings_by_category.values.flatten.index_by(&:key)
    @settings_hash[key]&.value || default
  end

  # Returns ISO 3166 country options for select_tag (alpha-2 codes).
  # Monaco and France are listed first (most common for Monaco real estate),
  # then remaining countries sorted alphabetically by name.
  def country_options
    all = ISO3166::Country.all.map { |c| ["#{c.iso_short_name} (#{c.alpha2})", c.alpha2] }
    priority = all.select { |_, code| %w[MC FR].include?(code) }.sort_by { |_, code| code == "MC" ? 0 : 1 }
    rest = all.reject { |_, code| %w[MC FR].include?(code) }.sort
    separator = [["───────────", "", {disabled: true}]]
    priority + separator + rest
  end

  # Returns XBRL-compliant country options for select_tag.
  # Values are pulled from the amsf_survey gem to ensure they match the schema.
  def xbrl_country_options(selected = nil)
    # Use the latest supported year from the gem (currently 2025)
    questionnaire = AmsfSurvey.questionnaire(industry: :real_estate, year: 2025)
    countries = questionnaire.question(:a3305).valid_values

    options = [["Select country...", ""]]
    countries.each do |label|
      if label =~ /\(([A-Z]{2}),\s/
        options << [label, Regexp.last_match(1)]
      end
    end
    options_for_select(options, selected)
  end
end
