# frozen_string_literal: true

# Authorization policy for DueDiligenceReview model.
# Reviews are append-only: create is allowed, but no update or destroy.
# Access is controlled through the parent Client's organization.
class DueDiligenceReviewPolicy < ApplicationPolicy
  def create?
    client_belongs_to_organization?
  end

  def permitted_attributes
    [:review_type, :trigger, :performed_at, :notes]
  end

  private

  def client_belongs_to_organization?
    return false unless record.respond_to?(:client)
    return false unless record.client

    record.client.organization_id == current_organization&.id
  end

  def current_organization
    account_user.account.organization
  end
end
