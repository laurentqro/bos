module ApplicationHelper
  def markdown(text)
    return "" if text.blank?

    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, escape_html: true)
    markdown = Redcarpet::Markdown.new(renderer)
    markdown.render(text).html_safe
  end

  # Format a dimensional survey answer (Hash of country code => value) as structured rows.
  # Returns array of {flag:, name:, value:} hashes, sorted by value descending.
  def format_dimensional_answer(hash)
    return [] if hash.blank?

    hash.sort_by { |_, v| -v }.map do |code, value|
      country = ISO3166::Country[code]
      {
        flag: country_flag_emoji(code),
        name: (country&.common_name || country&.iso_short_name || code),
        value: value.is_a?(Float) ? "#{value}%" : value.to_s
      }
    end
  end

  # Convert ISO alpha-2 country code to flag emoji (e.g. "FR" => "🇫🇷")
  def country_flag_emoji(code)
    return "" if code.blank?

    code.upcase.chars.map { |c| (c.ord - 65 + 0x1F1E6).chr(Encoding::UTF_8) }.join
  end
end
