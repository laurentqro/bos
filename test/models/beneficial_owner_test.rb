# frozen_string_literal: true

require "test_helper"

class BeneficialOwnerTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:one)
    @user = users(:one)
    @legal_entity = clients(:legal_entity)
    set_current_context(user: @user, organization: @organization)
  end

  # === Basic Validations ===

  test "valid beneficial owner with required attributes" do
    owner = BeneficialOwner.new(
      client: @legal_entity,
      name: "Jean Dupont"
    )
    assert owner.valid?
  end

  test "requires name" do
    owner = BeneficialOwner.new(
      client: @legal_entity
    )
    assert_not owner.valid?
    assert_includes owner.errors[:name], "can't be blank"
  end

  test "requires client" do
    owner = BeneficialOwner.new(
      name: "Jean Dupont"
    )
    assert_not owner.valid?
    assert_includes owner.errors[:client], "must exist"
  end

  # === Client Type Validation ===

  test "client must be PM or TRUST type" do
    pp_client = clients(:natural_person)
    owner = BeneficialOwner.new(
      client: pp_client,
      name: "Jean Dupont"
    )
    assert_not owner.valid?
    assert_includes owner.errors[:client], "must be a legal entity"
  end

  test "accepts PM client" do
    pm_client = clients(:legal_entity)
    owner = BeneficialOwner.new(
      client: pm_client,
      name: "Jean Dupont"
    )
    assert owner.valid?
  end

  test "accepts TRUST client" do
    trust_client = clients(:trust)
    owner = BeneficialOwner.new(
      client: trust_client,
      name: "Jean Dupont"
    )
    assert owner.valid?
  end

  # === Ownership Percentage Validation ===

  test "ownership_percentage can be nil" do
    owner = BeneficialOwner.new(
      client: @legal_entity,
      name: "Jean Dupont",
      ownership_percentage: nil
    )
    assert owner.valid?
  end

  test "ownership_percentage must be between 0 and 100" do
    owner = BeneficialOwner.new(
      client: @legal_entity,
      name: "Jean Dupont",
      ownership_percentage: 50.0
    )
    assert owner.valid?
  end

  test "ownership_percentage cannot be negative" do
    owner = BeneficialOwner.new(
      client: @legal_entity,
      name: "Jean Dupont",
      ownership_percentage: -1
    )
    assert_not owner.valid?
    assert owner.errors[:ownership_percentage].any? { |e| e.include?("greater than or equal to") }
  end

  test "ownership_percentage cannot exceed 100" do
    owner = BeneficialOwner.new(
      client: @legal_entity,
      name: "Jean Dupont",
      ownership_percentage: 101
    )
    assert_not owner.valid?
    assert owner.errors[:ownership_percentage].any? { |e| e.include?("less than or equal to") }
  end

  test "ownership_percentage allows boundary values" do
    [0, 100, 0.01, 99.99].each do |pct|
      owner = BeneficialOwner.new(
        client: @legal_entity,
        name: "Jean Dupont",
        ownership_percentage: pct
      )
      assert owner.valid?, "Expected ownership_percentage #{pct} to be valid"
    end
  end

  # === Control Type Validation ===

  test "control_type can be nil" do
    owner = BeneficialOwner.new(
      client: @legal_entity,
      name: "Jean Dupont",
      control_type: nil
    )
    assert owner.valid?
  end

  test "control_type must be valid when present" do
    owner = BeneficialOwner.new(
      client: @legal_entity,
      name: "Jean Dupont",
      control_type: "INVALID"
    )
    assert_not owner.valid?
    assert_includes owner.errors[:control_type], "is not included in the list"
  end

  test "accepts all valid control_types" do
    %w[DIRECT INDIRECT REPRESENTATIVE].each do |type|
      owner = BeneficialOwner.new(
        client: @legal_entity,
        name: "Jean Dupont",
        control_type: type
      )
      assert owner.valid?, "Expected control_type '#{type}' to be valid"
    end
  end

  # === PEP Validation ===

  test "is_pep defaults to false" do
    owner = BeneficialOwner.new(
      client: @legal_entity,
      name: "Jean Dupont"
    )
    assert_equal false, owner.is_pep
  end

  test "requires pep_type when is_pep is true" do
    owner = BeneficialOwner.new(
      client: @legal_entity,
      name: "Jean Dupont",
      is_pep: true
    )
    assert_not owner.valid?
    assert_includes owner.errors[:pep_type], "can't be blank"
  end

  test "pep_type not required when is_pep is false" do
    owner = BeneficialOwner.new(
      client: @legal_entity,
      name: "Jean Dupont",
      is_pep: false
    )
    assert owner.valid?
  end

  test "pep_type must be valid when present" do
    owner = BeneficialOwner.new(
      client: @legal_entity,
      name: "Jean Dupont",
      is_pep: true,
      pep_type: "INVALID"
    )
    assert_not owner.valid?
    assert_includes owner.errors[:pep_type], "is not included in the list"
  end

  test "accepts all valid pep_types" do
    %w[DOMESTIC FOREIGN INTL_ORG].each do |type|
      owner = BeneficialOwner.new(
        client: @legal_entity,
        name: "Jean Dupont",
        is_pep: true,
        pep_type: type
      )
      assert owner.valid?, "Expected pep_type '#{type}' to be valid"
    end
  end

  # === Associations ===

  test "belongs to client" do
    owner = beneficial_owners(:owner_one)
    assert_instance_of Client, owner.client
  end

  test "can access organization through client" do
    owner = beneficial_owners(:owner_one)
    assert_equal @organization, owner.client.organization
  end

  # === Scopes ===

  test "peps scope returns only PEP beneficial owners" do
    pep_owner = beneficial_owners(:pep_owner)
    regular_owner = beneficial_owners(:owner_one)

    peps = BeneficialOwner.peps
    assert_includes peps, pep_owner
    assert_not_includes peps, regular_owner
  end

  test "for_client scope filters by client" do
    owner = beneficial_owners(:owner_one)
    other_owner = beneficial_owners(:other_client_owner)

    client_owners = BeneficialOwner.for_client(@legal_entity)
    assert_includes client_owners, owner
    assert_not_includes client_owners, other_owner
  end

  # === AmsfConstants ===

  test "includes AmsfConstants" do
    assert BeneficialOwner.include?(AmsfConstants)
  end

  # === Verification Fields (AMSF Data Capture) ===

  test "source_of_wealth_verified defaults to false" do
    owner = BeneficialOwner.new
    assert_equal false, owner.source_of_wealth_verified
  end

  test "identification_verified defaults to false" do
    owner = BeneficialOwner.new
    assert_equal false, owner.identification_verified
  end

  # === Net Worth Range ===

  test "net_worth_range accepts valid values" do
    %w[UNDER_5M 5M_TO_50M OVER_50M].each do |range|
      owner = BeneficialOwner.new(
        client: @legal_entity,
        name: "Test",
        net_worth_range: range
      )
      assert owner.valid?, "Expected net_worth_range '#{range}' to be valid"
    end
  end

  test "net_worth_range rejects invalid values" do
    owner = BeneficialOwner.new(
      client: @legal_entity,
      name: "Test",
      net_worth_range: "INVALID"
    )
    assert_not owner.valid?
    assert_includes owner.errors[:net_worth_range], "is not included in the list"
  end

  test "net_worth_range is optional" do
    owner = BeneficialOwner.new(
      client: @legal_entity,
      name: "Test",
      net_worth_range: nil
    )
    assert owner.valid?
  end

  # === HNWI/UHNWI Classification ===

  test "hnwis scope returns beneficial owners with 5M_TO_50M or OVER_50M" do
    hnwi = beneficial_owners(:hnwi_owner)
    uhnwi = beneficial_owners(:uhnwi_owner)
    low_net_worth = beneficial_owners(:low_net_worth_owner)

    hnwis = BeneficialOwner.hnwis

    assert_includes hnwis, hnwi, "5M_TO_50M owner should be in hnwis scope"
    assert_includes hnwis, uhnwi, "OVER_50M owner should also be in hnwis scope"
    assert_not_includes hnwis, low_net_worth, "UNDER_5M owner should not be in hnwis scope"
  end

  test "uhnwis scope returns only OVER_50M beneficial owners" do
    hnwi = beneficial_owners(:hnwi_owner)
    uhnwi = beneficial_owners(:uhnwi_owner)

    uhnwis = BeneficialOwner.uhnwis

    assert_includes uhnwis, uhnwi, "OVER_50M owner should be in uhnwis scope"
    assert_not_includes uhnwis, hnwi, "5M_TO_50M owner should not be in uhnwis scope"
  end

  test "uhnwi is always a subset of hnwi" do
    uhnwis = BeneficialOwner.uhnwis
    hnwis = BeneficialOwner.hnwis

    uhnwis.each do |uhnwi|
      assert_includes hnwis, uhnwi, "UHNWI #{uhnwi.name} must also be an HNWI"
    end
  end

  test "hnwi? returns true for 5M_TO_50M and OVER_50M" do
    hnwi = beneficial_owners(:hnwi_owner)
    uhnwi = beneficial_owners(:uhnwi_owner)
    low = beneficial_owners(:low_net_worth_owner)

    assert hnwi.hnwi?, "5M_TO_50M owner should be HNWI"
    assert uhnwi.hnwi?, "OVER_50M owner should also be HNWI"
    assert_not low.hnwi?, "UNDER_5M owner should not be HNWI"
  end

  test "uhnwi? returns true only for OVER_50M" do
    hnwi = beneficial_owners(:hnwi_owner)
    uhnwi = beneficial_owners(:uhnwi_owner)

    assert uhnwi.uhnwi?, "OVER_50M owner should be UHNWI"
    assert_not hnwi.uhnwi?, "5M_TO_50M owner should not be UHNWI"
  end

  test "nil net_worth_range is neither HNWI nor UHNWI" do
    minimal = beneficial_owners(:minimal_owner)

    assert_nil minimal.net_worth_range
    assert_not minimal.hnwi?, "Owner with nil net_worth_range should not be HNWI"
    assert_not minimal.uhnwi?, "Owner with nil net_worth_range should not be UHNWI"
  end
end
