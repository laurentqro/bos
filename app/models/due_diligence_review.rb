# frozen_string_literal: true

class DueDiligenceReview < ApplicationRecord
  REVIEW_TYPES = %w[ENHANCED SIMPLIFIED].freeze
  TRIGGERS = %w[ONBOARDING ONGOING_MONITORING PEP_DETECTION HIGH_RISK_COUNTRY SUSPICIOUS_ACTIVITY OTHER].freeze

  belongs_to :client

  validates :review_type, presence: true, inclusion: {in: REVIEW_TYPES}
  validates :trigger, presence: true, inclusion: {in: TRIGGERS}
  validates :performed_at, presence: true
  validate :simplified_requires_onboarding_trigger

  private

  def simplified_requires_onboarding_trigger
    if review_type == "SIMPLIFIED" && trigger != "ONBOARDING"
      errors.add(:trigger, "must be ONBOARDING for simplified due diligence")
    end
  end
end
