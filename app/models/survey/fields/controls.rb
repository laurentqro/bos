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
    end
  end
end
