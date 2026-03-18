class RenameSettingsKeysToMatchFieldModules < ActiveRecord::Migration[8.1]
  RENAMES = {
    "legal_form" => "entity_legal_form",
    "total_employees" => "total_employee_headcount",
    "total_employees_fte" => "fte_employees",
    "annual_revenue" => "revenue_reporting_period",
    "last_external_audit" => "last_amsf_audit_recency",
    "is_foreign_subsidiary" => "is_branch_of_foreign_entity",
    "applies_aml_risk_ratings" => "applies_risk_ratings_to_clients",
    "written_aml_policy" => "has_written_aml_policies",
    "policy_last_updated" => "last_policy_update_date",
    "compliance_policies_author" => "policy_preparer",
    "high_risk_cdd_frequency" => "high_risk_purchase_sale_review_frequency"
  }.freeze

  def up
    RENAMES.each do |old_key, new_key|
      Setting.where(key: old_key).update_all(key: new_key)
    end
  end

  def down
    RENAMES.each do |old_key, new_key|
      Setting.where(key: new_key).update_all(key: old_key)
    end
  end
end
