# frozen_string_literal: true

require "test_helper"

class DueDiligenceReviewTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:one)
    @user = users(:one)
    set_current_context(user: @user, organization: @organization)
    @client = clients(:natural_person)
  end

  # === Validations ===

  test "valid review with all required attributes" do
    review = DueDiligenceReview.new(
      client: @client,
      review_type: "ENHANCED",
      trigger: "ONBOARDING",
      performed_at: Date.current
    )
    assert review.valid?
  end

  test "requires client" do
    review = DueDiligenceReview.new(
      review_type: "ENHANCED",
      trigger: "ONBOARDING",
      performed_at: Date.current
    )
    assert_not review.valid?
    assert_includes review.errors[:client], "must exist"
  end

  test "requires review_type" do
    review = DueDiligenceReview.new(
      client: @client,
      trigger: "ONBOARDING",
      performed_at: Date.current
    )
    assert_not review.valid?
    assert_includes review.errors[:review_type], "can't be blank"
  end

  test "requires trigger" do
    review = DueDiligenceReview.new(
      client: @client,
      review_type: "ENHANCED",
      performed_at: Date.current
    )
    assert_not review.valid?
    assert_includes review.errors[:trigger], "can't be blank"
  end

  test "requires performed_at" do
    review = DueDiligenceReview.new(
      client: @client,
      review_type: "ENHANCED",
      trigger: "ONBOARDING"
    )
    assert_not review.valid?
    assert_includes review.errors[:performed_at], "can't be blank"
  end

  test "review_type must be ENHANCED or SIMPLIFIED" do
    review = DueDiligenceReview.new(
      client: @client,
      review_type: "INVALID",
      trigger: "ONBOARDING",
      performed_at: Date.current
    )
    assert_not review.valid?
    assert_includes review.errors[:review_type], "is not included in the list"
  end

  test "trigger must be from valid list" do
    review = DueDiligenceReview.new(
      client: @client,
      review_type: "ENHANCED",
      trigger: "INVALID",
      performed_at: Date.current
    )
    assert_not review.valid?
    assert_includes review.errors[:trigger], "is not included in the list"
  end

  test "accepts all valid EDD triggers" do
    %w[ONBOARDING ONGOING_MONITORING PEP_DETECTION HIGH_RISK_COUNTRY SUSPICIOUS_ACTIVITY OTHER].each do |trigger|
      review = DueDiligenceReview.new(
        client: @client,
        review_type: "ENHANCED",
        trigger: trigger,
        performed_at: Date.current
      )
      assert review.valid?, "Expected trigger '#{trigger}' to be valid for ENHANCED, errors: #{review.errors.full_messages}"
    end
  end

  test "SIMPLIFIED review_type only allows ONBOARDING trigger" do
    review = DueDiligenceReview.new(
      client: @client,
      review_type: "SIMPLIFIED",
      trigger: "ONGOING_MONITORING",
      performed_at: Date.current
    )
    assert_not review.valid?
    assert_includes review.errors[:trigger], "must be ONBOARDING for simplified due diligence"
  end

  test "SIMPLIFIED review_type accepts ONBOARDING trigger" do
    review = DueDiligenceReview.new(
      client: @client,
      review_type: "SIMPLIFIED",
      trigger: "ONBOARDING",
      performed_at: Date.current
    )
    assert review.valid?
  end

  test "notes are optional" do
    review = DueDiligenceReview.new(
      client: @client,
      review_type: "ENHANCED",
      trigger: "ONBOARDING",
      performed_at: Date.current,
      notes: nil
    )
    assert review.valid?
  end

  # === Associations ===

  test "belongs to client" do
    review = DueDiligenceReview.new(client: @client)
    assert_equal @client, review.client
  end
end
