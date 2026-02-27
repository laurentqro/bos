# frozen_string_literal: true

class Survey
  module Fields
    module Controls
      # C1 — aC1102A: Total employees at end of reporting period (reuses Q188/a3301)
      # Type: xbrli:integerItemType — settings-based
      def ac1102a
        setting_value_for("total_employee_headcount")
      end

      # C2 — aC1102: FTE employees at end of reporting period
      # Type: xbrli:decimalItemType — settings-based
      def ac1102
        setting_value_for("fte_employees")
      end

      # C3 — aC1101Z: Hours on AML/CFT compliance per month
      # Type: xbrli:decimalItemType — settings-based
      def ac1101z
        setting_value_for("aml_compliance_hours_per_month")
      end

      # C4 — aC114: Has board/senior management?
      # Type: enum (Oui/Non) — settings-based
      def ac114
        setting_value_for("has_board_or_senior_management")
      end

      # C5 — aC1106: Has compliance department?
      # Type: enum (Oui/Non) — settings-based
      def ac1106
        setting_value_for("has_compliance_department")
      end

      # C6 — aC1518A: Entity is part of a group?
      # Type: enum (Oui/Non) — settings-based
      def ac1518a
        setting_value_for("entity_is_part_of_group")
      end

      # C7 — aC1201: Has written AML/CFT policies and procedures?
      # Type: enum (Oui/Non) — settings-based
      def ac1201
        setting_value_for("has_written_aml_policies")
      end

      # C8 — aC1202: Policies approved by board/senior management?
      # Type: enum (Oui/Non) — settings-based, conditional on aC114
      def ac1202
        return nil unless ac114 == "Oui"
        setting_value_for("policies_approved_by_board")
      end

      # C9 — aC1203: Policies disseminated to all employees?
      # Type: enum (Oui/Non) — settings-based, conditional on aC1201
      def ac1203
        return nil unless ac1201 == "Oui"
        setting_value_for("policies_disseminated_to_employees")
      end

      # C10 — aC1204: Ensured employees know the policies?
      # Type: enum (Oui/Non) — settings-based, conditional on aC1201
      def ac1204
        return nil unless ac1201 == "Oui"
        setting_value_for("employees_aware_of_policies")
      end

      # C11 — aC1205: Updated AML/CFT policies in past year?
      # Type: enum (Oui/Non) — settings-based, conditional on aC1201
      def ac1205
        return nil unless ac1201 == "Oui"
        setting_value_for("policies_updated_past_year")
      end

      # C12 — aC1206: Date of last policy update
      # Type: xbrli:dateItemType — settings-based, conditional on aC1201
      def ac1206
        return nil unless ac1201 == "Oui"
        setting_value_for("last_policy_update_date")
      end

      # C13 — aC1207: Systematic tracking of policy changes?
      # Type: enum (Oui/Non) — settings-based, conditional on aC1201
      def ac1207
        return nil unless ac1201 == "Oui"
        setting_value_for("systematic_policy_change_tracking")
      end

      # C14 — aC1209B: Has group-wide AML/CFT program?
      # Type: enum (Oui/Non) — settings-based, conditional on aC1518A
      def ac1209b
        return nil unless ac1518a == "Oui"
        setting_value_for("has_group_aml_program")
      end

      # C15 — aC1209C: Analyzed group AML program for local compliance?
      # Type: enum (Oui/Non) — settings-based, conditional on aC1209B
      def ac1209c
        return nil unless ac1209b == "Oui"
        setting_value_for("group_aml_program_compliance_analyzed")
      end

      # C16 — aC1208: Who prepared the policies?
      # Type: enum (4 values) — settings-based, conditional on aC1201
      def ac1208
        return nil unless ac1201 == "Oui"
        setting_value_for("policy_preparer")
      end

      # C17 — aC1209: Has self-assessed AML/CFT procedures adequacy?
      # Type: enum (Oui/Non) — settings-based, conditional on aC1201
      def ac1209
        return nil unless ac1201 == "Oui"
        setting_value_for("self_assessed_aml_adequacy")
      end

      # C18 — aC1301: Board/senior management demonstrates overall AML/CFT responsibility?
      # Type: enum (Oui/Non) — settings-based, conditional on aC114
      def ac1301
        return nil unless ac114 == "Oui"
        setting_value_for("board_demonstrates_aml_responsibility")
      end

      # C19 — aC1302: Board/senior management receives regular AML/CFT reports?
      # Type: enum (Oui/Non) — settings-based, conditional on aC114
      def ac1302
        return nil unless ac114 == "Oui"
        setting_value_for("board_receives_aml_reports")
      end

      # C20 — aC1303: Board/senior management ensures AML/CFT shortcomings are corrected?
      # Type: enum (Oui/Non) — settings-based, conditional on aC114
      def ac1303
        return nil unless ac114 == "Oui"
        setting_value_for("board_corrects_aml_shortcomings")
      end

      # C21 — aC1304: Senior management approves high-risk client acceptance?
      # Type: enum (Oui/Non) — settings-based, conditional on aC114
      def ac1304
        return nil unless ac114 == "Oui"
        setting_value_for("senior_mgmt_approves_high_risk_clients")
      end

      # C22 — aC1401: Entity had AML/CFT violations in past 5 years?
      # Type: enum (Oui/Non) — settings-based
      def ac1401
        setting_value_for("had_aml_violations_past_5_years")
      end

      # C23 — aC1402: Total AML/CFT violations in past 5 years
      # Type: xbrli:integerItemType — settings-based, conditional on aC1401
      def ac1402
        return nil unless ac1401 == "Oui"
        setting_value_for("aml_violations_count_past_5_years")
      end

      # C24 — aC1403: Number and type of AML/CFT violations
      # Type: xbrli:stringItemType — settings-based, conditional on aC1401
      def ac1403
        return nil unless ac1401 == "Oui"
        setting_value_for("aml_violations_description")
      end

      # C25 — aC1501: AML/CFT training provided to directors/management?
      # Type: enum (Oui/Non) — settings-based, conditional on aC114
      def ac1501
        return nil unless ac114 == "Oui"
        setting_value_for("aml_training_provided_to_directors")
      end

      # C26 — aC1503B: AML/CFT training provided to office employees?
      # Type: enum (Oui/Non) — settings-based
      def ac1503b
        setting_value_for("aml_training_provided_to_staff")
      end

      # C27 — aC1506: Total employees trained on AML/CFT
      # Type: xbrli:integerItemType — settings-based
      def ac1506
        setting_value_for("total_employees_trained_aml")
      end

      # ============================================================
      # Section 1.6 — CDD (C28–C66)
      # ============================================================

      # C28 — aC1625: Records ID card info for NP clients?
      # Type: enum (Oui/Non) — settings-based
      def ac1625
        setting_value_for("records_id_card_info")
      end

      # C29 — aC1626: Records passport info?
      # Type: enum (Oui/Non) — settings-based
      def ac1626
        setting_value_for("records_passport_info")
      end

      # C30 — aC1627: Records residence permit info?
      # Type: enum (Oui/Non) — settings-based
      def ac1627
        setting_value_for("records_residence_permit_info")
      end

      # C31 — aC168: Records proof of address?
      # Type: enum (Oui/Non) — settings-based
      def ac168
        setting_value_for("records_proof_of_address")
      end

      # C32 — aC1629: Records other individual info?
      # Type: enum (Oui/Non) — settings-based
      def ac1629
        setting_value_for("records_other_individual_info")
      end

      # C33 — aC1630: Specify other individual info
      # Type: xbrli:stringItemType — settings-based, conditional on aC1629
      def ac1630
        return nil unless ac1629 == "Oui"
        setting_value_for("other_individual_info_details")
      end

      # C34 — aC1601: All required NP elements kept on file?
      # Type: enum (Oui/Non) — settings-based
      def ac1601
        setting_value_for("all_np_elements_on_file")
      end

      # C35 — aC1602: Specify which elements not collected
      # Type: xbrli:stringItemType — settings-based, conditional on aC1601 == "Non"
      def ac1602
        return nil unless ac1601 == "Non"
        setting_value_for("missing_np_elements_description")
      end

      # C36 — aC1631: Records commercial registry extract for LE?
      # Type: enum (Oui/Non) — settings-based
      def ac1631
        setting_value_for("records_commercial_registry_extract")
      end

      # C37 — aC1633: Records articles of association for LE?
      # Type: enum (Oui/Non) — settings-based
      def ac1633
        setting_value_for("records_articles_of_association")
      end

      # C38 — aC1634: Records minutes of general assembly for LE?
      # Type: enum (Oui/Non) — settings-based
      def ac1634
        setting_value_for("records_minutes_of_assembly")
      end

      # C39 — aC1635: Records BO identity documents for LE?
      # Type: enum (Oui/Non) — settings-based
      def ac1635
        setting_value_for("records_bo_identity_documents")
      end

      # C40 — aC1636: Records other LE/construction data?
      # Type: enum (Oui/Non) — settings-based
      def ac1636
        setting_value_for("records_other_le_data")
      end

      # C41 — aC1637: Specify other LE data
      # Type: xbrli:stringItemType — settings-based, conditional on aC1636
      def ac1637
        return nil unless ac1636 == "Oui"
        setting_value_for("other_le_data_details")
      end

      # C42 — aC1608: Former client data accessible to AMSF on request?
      # Type: enum (Oui/Non) — settings-based
      def ac1608
        setting_value_for("former_client_data_accessible_to_amsf")
      end

      # C43 — aC1635A: All documents systematically retained?
      # Type: enum (Oui/Non) — settings-based
      def ac1635a
        setting_value_for("documents_systematically_retained")
      end

      # C44 — aC1638A: Retains summary documents?
      # Type: enum (Oui/Non) — settings-based
      def ac1638a
        setting_value_for("retains_summary_documents")
      end

      # C45 — aC1639A: Info stored in database?
      # Type: enum (Oui/Non) — settings-based, conditional on aC1638A
      def ac1639a
        return nil unless ac1638a == "Oui"
        setting_value_for("info_stored_in_database")
      end

      # C46 — aC1641A: Uses CDD tools?
      # Type: enum (Oui/Non) — settings-based
      def ac1641a
        setting_value_for("uses_cdd_tools")
      end

      # C47 — aC1640A: Which CDD tools?
      # Type: xbrli:stringItemType — settings-based, conditional on aC1641A
      def ac1640a
        return nil unless ac1641a == "Oui"
        setting_value_for("cdd_tools_description")
      end

      # C48 — aC1642A: CDD tool results systematically stored?
      # Type: enum (Oui/Non) — settings-based, conditional on aC1641A
      def ac1642a
        return nil unless ac1641a == "Oui"
        setting_value_for("cdd_results_systematically_stored")
      end

      # C49 — aC1609: Risk-based approach for CDD?
      # Type: enum (Oui/Non) — settings-based
      def ac1609
        setting_value_for("risk_based_approach_for_cdd")
      end

      # C50 — aC1610: Policies distinguish CDD levels?
      # Type: enum (Oui/Non) — settings-based, conditional on aC1609
      def ac1610
        return nil unless ac1609 == "Oui"
        setting_value_for("policies_distinguish_cdd_levels")
      end

      # C51 — aC1611: Total unique active clients
      # Type: xbrli:integerItemType — settings-based, conditional on aC1609
      def ac1611
        return nil unless ac1609 == "Oui"
        setting_value_for("total_unique_active_clients_cdd")
      end

      # C52 — aC1612A: Implemented simplified due diligence?
      # Type: enum (Oui/Non) — settings-based, conditional on aC1609
      def ac1612a
        return nil unless ac1609 == "Oui"
        setting_value_for("implemented_simplified_dd")
      end

      # C53 — aC1612: Total clients with simplified DD
      # Type: xbrli:integerItemType — settings-based, conditional on aC1612A
      def ac1612
        return nil unless ac1612a == "Oui"
        setting_value_for("simplified_dd_client_count")
      end

      # C54 — aC1614: Identifies/verifies clients using reliable independent info?
      # Type: enum (Oui/Non) — settings-based
      def ac1614
        setting_value_for("verifies_clients_with_reliable_info")
      end

      # C55 — aC1615: CDD policies include client acceptance/identification procedures?
      # Type: enum (Oui/Non) — settings-based
      def ac1615
        setting_value_for("cdd_policies_include_acceptance_procedures")
      end

      # C56 — aC1622F: Uses third parties for CDD?
      # Type: enum (Oui/Non) — settings-based
      def ac1622f
        setting_value_for("uses_third_parties_for_cdd")
      end

      # C57 — aC1622A: Difficulties receiving CDD info from third parties?
      # Type: enum (Oui/Non) — settings-based, conditional on aC1622F
      def ac1622a
        return nil unless ac1622f == "Oui"
        setting_value_for("difficulties_receiving_cdd_from_third_parties")
      end

      # C58 — aC1622B: Main reason for difficulties
      # Type: xbrli:stringItemType — settings-based, conditional on aC1622A
      def ac1622b
        return nil unless ac1622a == "Oui"
        setting_value_for("cdd_difficulties_reason")
      end

      # C59 — aC1620: Enhanced identification for high-risk clients?
      # Type: enum (Oui/Non) — settings-based, conditional on aC1609
      def ac1620
        return nil unless ac1609 == "Oui"
        setting_value_for("enhanced_id_for_high_risk_clients")
      end

      # C60 — aC1617: Examines source of wealth before relationship?
      # Type: enum (Oui/Non) — settings-based
      def ac1617
        setting_value_for("examines_source_of_wealth")
      end

      # C61 — aC1616B: Frequency of high-risk purchase/sale client review
      # Type: enum (5 values) — settings-based, conditional on aC1609
      def ac1616b
        return nil unless ac1609 == "Oui"
        setting_value_for("high_risk_purchase_sale_review_frequency")
      end

      # C62 — aC1616A: Frequency of high-risk rental client review
      # Type: enum (5 values) — settings-based, conditional on aC1609
      def ac1616a
        return nil unless ac1609 == "Oui"
        setting_value_for("high_risk_rental_review_frequency")
      end

      # C63 — aC1618: Other measures for high-risk clients?
      # Type: enum (Oui/Non) — settings-based, conditional on aC1609
      def ac1618
        return nil unless ac1609 == "Oui"
        setting_value_for("other_measures_for_high_risk_clients")
      end

      # C64 — aC1619: Specify other high-risk measures
      # Type: xbrli:stringItemType — settings-based, conditional on aC1618
      def ac1619
        return nil unless ac1618 == "Oui"
        setting_value_for("other_high_risk_measures_description")
      end

      # C65 — aC1616C: Clients use cryptocurrency for real estate?
      # Type: enum (Oui/Non) — settings-based
      def ac1616c
        setting_value_for("clients_use_crypto_for_real_estate")
      end

      # C66 — aC1621: How entity verifies virtual asset BOs
      # Type: xbrli:stringItemType — settings-based, conditional on aC1616C
      def ac1621
        return nil unless ac1616c == "Oui"
        setting_value_for("virtual_asset_bo_verification_method")
      end

      # ============================================================
      # Section 1.7 — EDD (C67–C69)
      # ============================================================

      # C67 — aC1701: Total EDD clients at onboarding
      # Type: xbrli:integerItemType — settings-based, conditional on aC1609
      def ac1701
        return nil unless ac1609 == "Oui"
        setting_value_for("edd_clients_at_onboarding_count")
      end

      # C68 — aC1702: Total EDD clients during ongoing relationship
      # Type: xbrli:integerItemType — settings-based, conditional on aC1609
      def ac1702
        return nil unless ac1609 == "Oui"
        setting_value_for("edd_clients_ongoing_count")
      end

      # C69 — aC1703: Percentage of EDD clients
      # Type: xbrli:pureItemType (0–100) — settings-based, conditional on aC1609
      def ac1703
        return nil unless ac1609 == "Oui"
        setting_value_for("edd_clients_percentage")
      end
    end
  end
end
