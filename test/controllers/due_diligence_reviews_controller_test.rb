# frozen_string_literal: true

require "test_helper"

class DueDiligenceReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @account = accounts(:one)
    @organization = organizations(:one)
    @client = clients(:natural_person)
  end

  # === Authentication ===

  test "redirects to login when not authenticated" do
    post client_due_diligence_reviews_path(@client)
    assert_redirected_to new_user_session_path
  end

  # === Create ===

  test "creates EDD review with valid params" do
    sign_in @user

    assert_difference "DueDiligenceReview.count", 1 do
      post client_due_diligence_reviews_path(@client), params: {
        due_diligence_review: {
          review_type: "ENHANCED",
          trigger: "ONBOARDING",
          performed_at: Date.current,
          notes: "Initial EDD at onboarding"
        }
      }
    end

    review = DueDiligenceReview.last
    assert_equal @client, review.client
    assert_equal "ENHANCED", review.review_type
    assert_equal "ONBOARDING", review.trigger
    assert_equal Date.current, review.performed_at
    assert_equal "Initial EDD at onboarding", review.notes
    assert_redirected_to client_path(@client)
  end

  test "creates SDD review with ONBOARDING trigger" do
    sign_in @user

    assert_difference "DueDiligenceReview.count", 1 do
      post client_due_diligence_reviews_path(@client), params: {
        due_diligence_review: {
          review_type: "SIMPLIFIED",
          trigger: "ONBOARDING",
          performed_at: Date.current,
          notes: "Low-risk regulated entity"
        }
      }
    end

    review = DueDiligenceReview.last
    assert_equal "SIMPLIFIED", review.review_type
    assert_equal "ONBOARDING", review.trigger
  end

  test "rejects create with missing review_type" do
    sign_in @user

    assert_no_difference "DueDiligenceReview.count" do
      post client_due_diligence_reviews_path(@client), params: {
        due_diligence_review: {
          trigger: "ONBOARDING",
          performed_at: Date.current
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "rejects SDD review with non-ONBOARDING trigger" do
    sign_in @user

    assert_no_difference "DueDiligenceReview.count" do
      post client_due_diligence_reviews_path(@client), params: {
        due_diligence_review: {
          review_type: "SIMPLIFIED",
          trigger: "ONGOING_MONITORING",
          performed_at: Date.current
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "returns 404 for client in another organization" do
    sign_in @user
    other_client = clients(:other_org_client)

    post client_due_diligence_reviews_path(other_client), params: {
      due_diligence_review: {
        review_type: "ENHANCED",
        trigger: "ONBOARDING",
        performed_at: Date.current
      }
    }

    assert_response :not_found
  end

  # === No edit/update/destroy routes ===

  test "no PATCH route exists for reviews" do
    assert_raises(ActionController::RoutingError) do
      Rails.application.routes.recognize_path(
        "/clients/#{@client.id}/due_diligence_reviews/1",
        method: :patch
      )
    end
  end

  test "no DELETE route exists for reviews" do
    assert_raises(ActionController::RoutingError) do
      Rails.application.routes.recognize_path(
        "/clients/#{@client.id}/due_diligence_reviews/1",
        method: :delete
      )
    end
  end
end
