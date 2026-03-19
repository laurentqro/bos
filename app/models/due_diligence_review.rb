# frozen_string_literal: true

class DueDiligenceReview < ApplicationRecord
  REVIEW_TYPES = %w[ENHANCED SIMPLIFIED].freeze
  TRIGGERS = %w[ONBOARDING ONGOING_MONITORING PEP_DETECTION HIGH_RISK_COUNTRY SUSPICIOUS_ACTIVITY OTHER].freeze
  EDD_TRIGGERS = TRIGGERS.freeze
  SDD_TRIGGERS = %w[ONBOARDING].freeze

  REVIEW_TYPE_LABELS = {
    "ENHANCED" => "Enhanced (EDD)",
    "SIMPLIFIED" => "Simplified (SDD)"
  }.freeze

  TRIGGER_LABELS = {
    "ONBOARDING" => "Onboarding",
    "ONGOING_MONITORING" => "Ongoing monitoring",
    "PEP_DETECTION" => "PEP detection",
    "HIGH_RISK_COUNTRY" => "High-risk country",
    "SUSPICIOUS_ACTIVITY" => "Suspicious activity",
    "OTHER" => "Other"
  }.freeze

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
