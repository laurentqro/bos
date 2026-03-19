import { Controller } from "@hotwired/stimulus"

// Filters trigger options based on review_type selection.
// SDD reviews only allow ONBOARDING trigger.
export default class extends Controller {
  static targets = ["reviewType", "trigger"]

  connect() {
    this.filterTriggers()
  }

  filterTriggers() {
    if (!this.hasReviewTypeTarget || !this.hasTriggerTarget) return

    const reviewType = this.reviewTypeTarget.value
    const triggerSelect = this.triggerTarget

    Array.from(triggerSelect.options).forEach(option => {
      if (option.value === "") return // keep blank option
      if (reviewType === "SIMPLIFIED") {
        option.hidden = option.value !== "ONBOARDING"
        if (option.value !== "ONBOARDING" && option.selected) {
          triggerSelect.value = "ONBOARDING"
        }
      } else {
        option.hidden = false
      }
    })

    // Auto-select ONBOARDING for SDD
    if (reviewType === "SIMPLIFIED") {
      triggerSelect.value = "ONBOARDING"
    }
  }
}
