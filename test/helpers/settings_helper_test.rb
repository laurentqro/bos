require "test_helper"

class SettingsHelperTest < ActionView::TestCase
  test "country_options returns all ISO 3166 countries" do
    options = country_options
    codes = options.map { |o| o[1] }.reject(&:blank?)

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

  test "country_options sorts remaining countries alphabetically with unicode awareness" do
    options = country_options
    rest = options[3..] # skip MC, FR, separator

    # Åland Islands (AX) should sort near the top with other "A" countries,
    # not after "Z" as it would with naive byte-order sorting
    aland_index = rest.index { |_, code| code == "AX" }
    zimbabwe_index = rest.index { |_, code| code == "ZW" }

    assert aland_index < zimbabwe_index, "Åland Islands should sort before Zimbabwe"
  end

  test "country_options includes non-ASCII country names" do
    options = country_options
    aland = options.find { |_, code| code == "AX" }

    assert_not_nil aland, "Should include Åland Islands (AX)"
    assert_match(/Åland/, aland.first, "Label should contain Åland")
  end

  test "country_options formats labels as 'Name (CODE)'" do
    options = country_options
    mc = options.find { |o| o[1] == "MC" }

    assert_match(/\(MC\)$/, mc.first, "Label should end with (MC)")
  end
end
