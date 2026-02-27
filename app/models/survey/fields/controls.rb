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
    end
  end
end
