require "test_helper"

class SettingsHelperTest < ActionView::TestCase
  test "country_options returns all ISO 3166 countries" do
    options = country_options
    codes = options.map { |o| o.is_a?(Array) ? (o[1].is_a?(Hash) ? nil : o[1]) : o }.compact

    assert codes.include?("MC"), "Should include Monaco"
    assert codes.include?("FR"), "Should include France"
    assert codes.include?("JP"), "Should include Japan"
    assert codes.length > 200, "Should have full ISO 3166 list, got #{codes.length}"
  end

  test "country_options prioritizes Monaco then France" do
    options = country_options

    assert_equal "MC", options[0][1], "Monaco should be first"
    assert_equal "FR", options[1][1], "France should be second"
  end

  test "country_options has a disabled separator after priority countries" do
    options = country_options
    separator = options[2]

    assert_equal 3, separator.length, "Separator should have 3 elements (label, value, attrs)"
    assert_equal true, separator[2][:disabled], "Separator should be disabled"
  end

  test "country_options sorts remaining countries alphabetically" do
    options = country_options
    rest = options[3..] # skip MC, FR, separator
    names = rest.map(&:first)

    assert_equal names, names.sort, "Countries after separator should be alphabetically sorted"
  end

  test "country_options formats labels as 'Name (CODE)'" do
    options = country_options
    mc = options.find { |o| o[1] == "MC" }

    assert_match(/\(MC\)$/, mc.first, "Label should end with (MC)")
  end
end
