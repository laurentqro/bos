# frozen_string_literal: true

# Append-only controller for DueDiligenceReview.
# Reviews are created from the client show page. No edit/update/destroy.
class DueDiligenceReviewsController < ApplicationController
  include OrganizationScoped

  before_action :set_client

  def create
    @review = @client.due_diligence_reviews.build(review_params)
    authorize @review

    if @review.save
      redirect_to @client, notice: "Due diligence review was successfully recorded."
    else
      @due_diligence_reviews = @client.due_diligence_reviews.order(performed_at: :desc, created_at: :desc)
      @due_diligence_review = @review
      render "clients/show", status: :unprocessable_entity
    end
  end

  private

  def set_client
    @client = policy_scope(Client).find_by(id: params[:client_id])
    render_not_found unless @client
  end

  def review_params
    params.expect(due_diligence_review: policy(@review || DueDiligenceReview.new(client: @client)).permitted_attributes)
  end
end
