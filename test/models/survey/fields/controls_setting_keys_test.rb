# frozen_string_literal: true

require "test_helper"

# Tests that controls.rb setting keys are semantic English, not XBRL field IDs.
# Each test verifies that the field method reads from the correct semantic key.
class Survey::Fields::ControlsSettingKeysTest < ActiveSupport::TestCase
  setup do
    @org = Organization.create!(account: accounts(:invited), name: "Test Agency", rci_number: "TEST001")
    @survey = Survey.new(organization: @org, year: 2025)
  end

  # === Revenue Fields ===

  test "a381 reads from reporting_period_revenue setting" do
    @org.settings.create!(key: "reporting_period_revenue", value: "500000", category: "entity_info")
    assert_equal 500_000.to_d, @survey.send(:a381)
  end

  test "a381 returns nil when setting is not set" do
    assert_nil @survey.send(:a381)
  end

  test "a3802 reads from revenue_in_monaco setting" do
    @org.settings.create!(key: "revenue_in_monaco", value: "300000", category: "entity_info")
    assert_equal 300_000.to_d, @survey.send(:a3802)
  end

  test "a3802 returns nil when setting is not set" do
    assert_nil @survey.send(:a3802)
  end

  test "a3803 reads from revenue_outside_monaco setting" do
    @org.settings.create!(key: "revenue_outside_monaco", value: "200000", category: "entity_info")
    assert_equal 200_000.to_d, @survey.send(:a3803)
  end

  test "a3803 returns nil when setting is not set" do
    assert_nil @survey.send(:a3803)
  end

  test "a3804 reads from last_vat_declaration_amount setting" do
    @org.settings.create!(key: "last_vat_declaration_amount", value: "50000", category: "entity_info")
    assert_equal 50_000.to_d, @survey.send(:a3804)
  end

  test "a3804 returns nil when setting is not set" do
    assert_nil @survey.send(:a3804)
  end

  # === Entity Changes ===

  test "a3307 reads from had_significant_changes setting" do
    @org.settings.create!(key: "had_significant_changes", value: "Oui", category: "entity_info")
    assert_equal "Oui", @survey.send(:a3307)
  end

  test "a3307 returns nil when setting is not set" do
    assert_nil @survey.send(:a3307)
  end

  test "a3308 reads from significant_changes_details setting" do
    @org.settings.create!(key: "significant_changes_details", value: "New management", category: "entity_info")
    assert_equal "New management", @survey.send(:a3308)
  end

  # === Compliance Hours ===

  test "ac1101z reads from monthly_compliance_hours setting" do
    @org.settings.create!(key: "monthly_compliance_hours", value: "40", category: "kyc_procedures")
    assert_equal "40", @survey.send(:ac1101z)
  end

  # === Board and Compliance ===

  test "ac114 reads from has_board_or_senior_management setting" do
    @org.settings.create!(key: "has_board_or_senior_management", value: "Oui", category: "entity_info")
    assert_equal "Oui", @survey.send(:ac114)
  end

  test "ac114 returns nil when setting is not set" do
    assert_nil @survey.send(:ac114)
  end

  test "ac1106 reads from has_compliance_department setting" do
    @org.settings.create!(key: "has_compliance_department", value: "Non", category: "entity_info")
    assert_equal "Non", @survey.send(:ac1106)
  end

  test "ac1106 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1106)
  end

  # === Cash Operations ===

  test "ac11401 reads from conducts_cash_operations setting" do
    @org.settings.create!(key: "conducts_cash_operations", value: "Oui", category: "entity_info")
    assert_equal "Oui", @survey.send(:ac11401)
  end

  test "ac11401 returns nil when setting is not set" do
    assert_nil @survey.send(:ac11401)
  end

  test "ac11402 reads from has_cash_aml_controls setting" do
    @org.settings.create!(key: "has_cash_aml_controls", value: "Oui", category: "entity_info")
    assert_equal "Oui", @survey.send(:ac11402)
  end

  test "ac11402 returns nil when setting is not set" do
    assert_nil @survey.send(:ac11402)
  end

  test "ac11403 reads from cash_controls_description setting" do
    @org.settings.create!(key: "cash_controls_description", value: "We check everything", category: "kyc_procedures")
    assert_equal "We check everything", @survey.send(:ac11403)
  end

  # === STR Reports ===

  test "ac11501b returns Oui when STR reports exist for the year" do
    @org.str_reports.create!(report_date: Date.new(2025, 6, 15), reason: "CASH")
    assert_equal "Oui", @survey.send(:ac11501b)
  end

  test "ac11501b returns Non when no STR reports exist for the year" do
    assert_equal "Non", @survey.send(:ac11501b)
  end

  test "ac11501b ignores STR reports from other years" do
    @org.str_reports.create!(report_date: Date.new(2024, 6, 15), reason: "CASH")
    assert_equal "Non", @survey.send(:ac11501b)
  end

  test "ac11501b ignores discarded STR reports" do
    @org.str_reports.create!(report_date: Date.new(2025, 6, 15), reason: "CASH", deleted_at: Time.current)
    assert_equal "Non", @survey.send(:ac11501b)
  end

  test "ac11502 reads from str_terrorism_financing_count setting" do
    @org.settings.create!(key: "str_terrorism_financing_count", value: "2", category: "compliance_policies")
    assert_equal 2, @survey.send(:ac11502)
  end

  test "ac11502 returns nil when setting is not set" do
    assert_nil @survey.send(:ac11502)
  end

  test "ac11504 reads from str_money_laundering_count setting" do
    @org.settings.create!(key: "str_money_laundering_count", value: "3", category: "compliance_policies")
    assert_equal 3, @survey.send(:ac11504)
  end

  test "ac11504 returns nil when setting is not set" do
    assert_nil @survey.send(:ac11504)
  end

  test "ac11508 reads from strengthened_internal_controls setting" do
    @org.settings.create!(key: "strengthened_internal_controls", value: "Oui", category: "compliance_policies")
    assert_equal "Oui", @survey.send(:ac11508)
  end

  test "ac11508 returns nil when setting is not set" do
    assert_nil @survey.send(:ac11508)
  end

  # === Training ===

  test "ac1501 reads from directors_received_aml_training setting" do
    @org.settings.create!(key: "directors_received_aml_training", value: "Oui", category: "compliance_policies")
    assert_equal "Oui", @survey.send(:ac1501)
  end

  test "ac1501 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1501)
  end

  test "ac1503b reads from staff_received_aml_training setting" do
    @org.settings.create!(key: "staff_received_aml_training", value: "Oui", category: "compliance_policies")
    assert_equal "Oui", @survey.send(:ac1503b)
  end

  test "ac1503b returns nil when setting is not set" do
    assert_nil @survey.send(:ac1503b)
  end

  test "ac1506 reads from employees_trained_aml_count setting" do
    @org.settings.create!(key: "employees_trained_aml_count", value: "8", category: "compliance_policies")
    assert_equal 8, @survey.send(:ac1506)
  end

  test "ac1506 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1506)
  end

  test "ac1518a reads from is_part_of_group setting" do
    @org.settings.create!(key: "is_part_of_group", value: "Non", category: "entity_info")
    assert_equal "Non", @survey.send(:ac1518a)
  end

  test "ac1518a returns nil when setting is not set" do
    assert_nil @survey.send(:ac1518a)
  end

  # === AML Policies ===

  test "ac1202 reads from policies_approved_by_board setting" do
    @org.settings.create!(key: "policies_approved_by_board", value: "Oui", category: "compliance_policies")
    assert_equal "Oui", @survey.send(:ac1202)
  end

  test "ac1202 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1202)
  end

  test "ac1203 reads from policies_distributed_to_staff setting" do
    @org.settings.create!(key: "policies_distributed_to_staff", value: "Oui", category: "compliance_policies")
    assert_equal "Oui", @survey.send(:ac1203)
  end

  test "ac1203 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1203)
  end

  test "ac1204 reads from policies_known_by_staff setting" do
    @org.settings.create!(key: "policies_known_by_staff", value: "Oui", category: "compliance_policies")
    assert_equal "Oui", @survey.send(:ac1204)
  end

  test "ac1204 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1204)
  end

  test "ac1205 reads from policies_updated_this_year setting" do
    @org.settings.create!(key: "policies_updated_this_year", value: "Oui", category: "compliance_policies")
    assert_equal "Oui", @survey.send(:ac1205)
  end

  test "ac1205 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1205)
  end

  test "ac1206 reads from policies_last_updated_date setting" do
    @org.settings.create!(key: "policies_last_updated_date", value: "2024-11-15", category: "compliance_policies")
    assert_equal "2024-11-15", @survey.send(:ac1206)
  end

  test "ac1207 reads from systematic_policy_change_tracking setting" do
    @org.settings.create!(key: "systematic_policy_change_tracking", value: "Oui", category: "compliance_policies")
    assert_equal "Oui", @survey.send(:ac1207)
  end

  test "ac1207 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1207)
  end

  test "ac1209 reads from self_assessed_aml_procedures setting" do
    @org.settings.create!(key: "self_assessed_aml_procedures", value: "Oui", category: "compliance_policies")
    assert_equal "Oui", @survey.send(:ac1209)
  end

  test "ac1209 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1209)
  end

  test "ac1209b reads from has_group_aml_program setting" do
    @org.settings.create!(key: "has_group_aml_program", value: "Oui", category: "compliance_policies")
    assert_equal "Oui", @survey.send(:ac1209b)
  end

  test "ac1209b returns nil when setting is not set" do
    assert_nil @survey.send(:ac1209b)
  end

  test "ac1209c reads from group_program_monaco_compliant setting" do
    @org.settings.create!(key: "group_program_monaco_compliant", value: "Non", category: "compliance_policies")
    assert_equal "Non", @survey.send(:ac1209c)
  end

  test "ac1209c returns nil when setting is not set" do
    assert_nil @survey.send(:ac1209c)
  end

  # === Board and Management ===

  test "ac1301 reads from board_demonstrates_aml_responsibility setting" do
    @org.settings.create!(key: "board_demonstrates_aml_responsibility", value: "Oui", category: "compliance_policies")
    assert_equal "Oui", @survey.send(:ac1301)
  end

  test "ac1301 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1301)
  end

  test "ac1302 reads from board_receives_aml_reports setting" do
    @org.settings.create!(key: "board_receives_aml_reports", value: "Oui", category: "compliance_policies")
    assert_equal "Oui", @survey.send(:ac1302)
  end

  test "ac1302 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1302)
  end

  test "ac1303 reads from board_addresses_aml_gaps setting" do
    @org.settings.create!(key: "board_addresses_aml_gaps", value: "Oui", category: "compliance_policies")
    assert_equal "Oui", @survey.send(:ac1303)
  end

  test "ac1303 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1303)
  end

  test "ac1304 reads from management_approves_high_risk_clients setting" do
    @org.settings.create!(key: "management_approves_high_risk_clients", value: "Oui", category: "compliance_policies")
    assert_equal "Oui", @survey.send(:ac1304)
  end

  test "ac1304 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1304)
  end

  # === AML Violations ===

  test "ac1401 reads from had_aml_violations_5_years setting" do
    @org.settings.create!(key: "had_aml_violations_5_years", value: "Non", category: "compliance_policies")
    assert_equal "Non", @survey.send(:ac1401)
  end

  test "ac1401 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1401)
  end

  test "ac1402 reads from aml_violation_count_5_years setting" do
    @org.settings.create!(key: "aml_violation_count_5_years", value: "1", category: "compliance_policies")
    assert_equal 1, @survey.send(:ac1402)
  end

  test "ac1402 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1402)
  end

  test "ac1403 reads from aml_violation_details setting" do
    @org.settings.create!(key: "aml_violation_details", value: "Minor issue", category: "compliance_policies")
    assert_equal "Minor issue", @survey.send(:ac1403)
  end

  # === CDD Records ===

  test "ac1629 reads from records_other_individual_info setting" do
    @org.settings.create!(key: "records_other_individual_info", value: "Oui", category: "kyc_procedures")
    assert_equal "Oui", @survey.send(:ac1629)
  end

  test "ac1629 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1629)
  end

  test "ac1630 reads from other_client_info_details setting" do
    @org.settings.create!(key: "other_client_info_details", value: "Risk profile details", category: "kyc_procedures")
    assert_equal "Risk profile details", @survey.send(:ac1630)
  end

  test "ac1602 reads from cdd_elements_not_collected setting" do
    @org.settings.create!(key: "cdd_elements_not_collected", value: "Historical transactions", category: "kyc_procedures")
    assert_equal "Historical transactions", @survey.send(:ac1602)
  end

  # === High-Risk CDD ===

  test "ac1618 reads from has_additional_high_risk_measures setting" do
    @org.settings.create!(key: "has_additional_high_risk_measures", value: "Oui", category: "kyc_procedures")
    assert_equal "Oui", @survey.send(:ac1618)
  end

  test "ac1618 returns nil when setting is not set" do
    assert_nil @survey.send(:ac1618)
  end

  test "ac1619 reads from additional_high_risk_measures_details setting" do
    @org.settings.create!(key: "additional_high_risk_measures_details", value: "Enhanced source of funds check", category: "kyc_procedures")
    assert_equal "Enhanced source of funds check", @survey.send(:ac1619)
  end

  test "ac1622a reads from has_third_party_cdd_difficulties setting" do
    @org.settings.create!(key: "has_third_party_cdd_difficulties", value: "Oui", category: "kyc_procedures")
    assert_equal "Oui", @survey.send(:ac1622a)
  end

  test "ac1622b reads from third_party_cdd_difficulties_details setting" do
    @org.settings.create!(key: "third_party_cdd_difficulties_details", value: "Legal reasons", category: "kyc_procedures")
    assert_equal "Legal reasons", @survey.send(:ac1622b)
  end

  test "ac1621 reads from virtual_asset_bo_verification_method setting" do
    @org.settings.create!(key: "virtual_asset_bo_verification_method", value: "Chainalysis", category: "kyc_procedures")
    assert_equal "Chainalysis", @survey.send(:ac1621)
  end

  # === PEP Screening ===

  test "ac11302 reads from pep_identification_measures setting" do
    @org.settings.create!(key: "pep_identification_measures", value: "Official lists", category: "kyc_procedures")
    assert_equal "Official lists", @survey.send(:ac11302)
  end

  test "ac11303 reads from pep_additional_procedures setting" do
    @org.settings.create!(key: "pep_additional_procedures", value: "Management approval", category: "kyc_procedures")
    assert_equal "Management approval", @survey.send(:ac11303)
  end

  # ac11305 moved to CrmCapabilities (continuous PEP screening is a CRM capability)

  test "ac11307 reads from all_pep_relationships_high_risk setting" do
    @org.settings.create!(key: "all_pep_relationships_high_risk", value: "Oui", category: "kyc_procedures")
    assert_equal "Oui", @survey.send(:ac11307)
  end

  test "ac11307 returns nil when setting is not set" do
    assert_nil @survey.send(:ac11307)
  end

  # === Sanctions ===

  # ac1125a moved to CrmCapabilities (asset freeze list checking is a CRM capability)

  test "ac11201 reads from policies_cover_targeted_financial_sanctions setting" do
    @org.settings.create!(key: "policies_cover_targeted_financial_sanctions", value: "Oui", category: "compliance_policies")
    assert_equal "Oui", @survey.send(:ac11201)
  end

  test "ac11201 returns nil when setting is not set" do
    assert_nil @survey.send(:ac11201)
  end

  # === Terrorism/Proliferation Declarations ===

  test "ac12236 reads from dbt_terrorism_financing_declarations setting" do
    @org.settings.create!(key: "dbt_terrorism_financing_declarations", value: "1", category: "compliance_policies")
    assert_equal 1, @survey.send(:ac12236)
  end

  test "ac12236 returns nil when setting is not set" do
    assert_nil @survey.send(:ac12236)
  end

  test "ac12237 reads from dbt_wmd_proliferation_declarations setting" do
    @org.settings.create!(key: "dbt_wmd_proliferation_declarations", value: "0", category: "compliance_policies")
    assert_equal 0, @survey.send(:ac12237)
  end

  test "ac12237 returns nil when setting is not set" do
    assert_nil @survey.send(:ac12237)
  end

  test "ac12333 reads from identified_terrorism_or_proliferation setting" do
    @org.settings.create!(key: "identified_terrorism_or_proliferation", value: "Non", category: "compliance_policies")
    assert_equal "Non", @survey.send(:ac12333)
  end

  test "ac12333 returns nil when setting is not set" do
    assert_nil @survey.send(:ac12333)
  end

  # === Section Comments ===

  test "a3701 reads from inherent_risk_section_comments setting" do
    @org.settings.create!(key: "inherent_risk_section_comments", value: "All good", category: "entity_info")
    assert_equal "All good", @survey.send(:a3701)
  end

  test "a3701a checks presence of inherent_risk_section_comments setting" do
    @org.settings.create!(key: "inherent_risk_section_comments", value: "Comments here", category: "entity_info")
    assert_equal "Oui", @survey.send(:a3701a)
  end

  test "a3701a returns Non when inherent_risk_section_comments setting is absent" do
    assert_equal "Non", @survey.send(:a3701a)
  end

  test "ac11601 reads from controls_section_comments setting" do
    @org.settings.create!(key: "controls_section_comments", value: "Some feedback", category: "compliance_policies")
    assert_equal "Some feedback", @survey.send(:ac11601)
  end

  test "ac116a checks presence of controls_section_comments setting" do
    @org.settings.create!(key: "controls_section_comments", value: "Feedback here", category: "compliance_policies")
    assert_equal "Oui", @survey.send(:ac116a)
  end

  test "ac116a returns Non when controls_section_comments setting is absent" do
    assert_equal "Non", @survey.send(:ac116a)
  end

  # === CDD Frequency ===

  test "ac1616a reads from high_risk_rental_cdd_frequency setting" do
    @org.settings.create!(key: "high_risk_rental_cdd_frequency", value: "> Annuel", category: "kyc_procedures")
    assert_equal "> Annuel", @survey.send(:ac1616a)
  end
end
