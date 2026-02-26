# frozen_string_literal: true

# Tab 4: Internal Controls
# Field methods for internal control measures
#
# Fields cover:
# - Staff training
# - Compliance function
# - Due diligence procedures (simplified, enhanced)
# - AML/CFT policies
# - Transaction monitoring
# - Sanctions screening
# - SAR (Suspicious Activity Reports) filing
# - Record keeping
# - Audit procedures
#
class Survey
  module Fields
    module Controls
      extend ActiveSupport::Concern
      include Helpers

      # XBRL legal form enumeration values
      # Maps short codes used in settings to full XBRL-compliant labels
      LEGAL_FORMS = {
        "AM" => "01. Associations monégasques",
        "ASC" => "02. Autres sociétés civiles",
        "AAJ" => "04. Autres arrangements juridiques",
        "DPE" => "05. Domaine Privé de l'Etat Monégasque",
        "EI" => "06. Entreprise individuelle",
        "FM" => "07. Fondation monégasque",
        "GIE" => "08. Groupement d'Intérêt économiques",
        "SNC" => "09. Sociétés en nom collectif",
        "SCI" => "10. Sociétés civiles immobilières",
        "SCP" => "11. Sociétés civiles particulières",
        "SCS" => "12. Sociétés en commandite simple",
        "SARL" => "13. Sociétés à responsabilité limitée",
        "SAM" => "14. Sociétés anonymes monégasques",
        "SCA" => "15. Sociétés en commandite par actions",
        "TRUST" => "16. Trusts",
        "INCONNU" => "17. Inconnu (LE)"
      }.freeze

      private

      # C70: Does entity apply AML/CFT risk ratings to clients?
      def ab1801b
        setting_value("applies_aml_risk_ratings")
      end

      # === Revenue ===

      # Reporting period revenue
      def a381
        setting_value("reporting_period_revenue")&.to_d
      end

      # Revenue in Monaco
      def a3802
        setting_value("revenue_in_monaco")&.to_d
      end

      # Revenue outside Monaco
      def a3803
        setting_value("revenue_outside_monaco")&.to_d
      end

      # Last annual VAT declaration amount
      def a3804
        setting_value("last_vat_declaration_amount")&.to_d
      end

      # === Due Diligence Procedures ===

      # Legal form of the entity - returns XBRL-compliant enumeration value
      def air33lf
        code = setting_value("legal_form")
        return nil if code.blank?

        LEGAL_FORMS[code] || LEGAL_FORMS["INCONNU"]
      end

      # Q189: Total employees (headcount) + non-salaried partners/owners
      # Same question as ac1102a — both read from total_employees
      def a3301
        setting_value("total_employees")&.to_i
      end

      # Q188: Is the professional card holder a legal entity?
      def air328
        setting_value("card_holder_is_legal_entity")
      end

      # Q190: Does entity have branches, subsidiaries, or agencies?
      def a3302
        organization.branches.exists? ? "Oui" : "Non"
      end

      # Q191: Total branches, subsidiaries, and agencies by country
      def a3303
        counts = organization.branches.group(:country).count
        counts.presence
      end

      # Is entity a branch/subsidiary of a foreign entity?
      def a3304
        setting_value("is_foreign_subsidiary") == "true" ? "Oui" : "Non"
      end

      # Same question, alternate field ID
      def a3304c
        a3304
      end

      # Parent company country (if entity is a branch/subsidiary of foreign entity)
      # Setting stores an ISO alpha-2 code; gem resolves to the XBRL enum label
      def a3305
        code = setting_value("parent_company_country")
        return if code.blank?

        questionnaire.question(:a3305).resolve_code(code)
      end

      # Q198: Has entity had significant changes during period?
      def a3307
        setting_value("had_significant_changes")
      end

      # Significant changes details
      def a3308
        setting_value("significant_changes_details")
      end

      # Q196: Shareholders with 25%+ ownership, grouped by nationality/country
      def a3306a
        counts = organization.entity_shareholders.group(:nationality).count
        counts.presence
      end

      # Q197: Entity's own beneficial owners (25%+ or controlling) by nationality
      def a3306b
        counts = organization.entity_beneficial_owners.group(:nationality).count
        counts.presence
      end

      # Q195: Foreign branches and subsidiaries (outside Monaco) by country
      def a3306
        counts = organization.branches.foreign.group(:country).count
        counts.presence
      end

      # CDD refresh
      # Q208: Total prospects rejected for AML/CFT/WMD reasons during the reporting period
      # Counts clients with rejection_reason set who became (were evaluated as) clients in the year
      def a3401
        clients_kept
          .where.not(rejection_reason: [nil, ""])
          .where(became_client_at: Date.new(year, 1, 1)..Date.new(year, 12, 31))
          .count
      end

      # Q210: Prospects rejected due to client attributes/activities/deficiencies
      # Counts clients rejected specifically for AML_CFT reasons (client-attributable)
      def a3403
        clients_kept
          .where(rejection_reason: "AML_CFT")
          .where(became_client_at: Date.new(year, 1, 1)..Date.new(year, 12, 31))
          .count
      end

      # Q211: Total client relationships terminated for AML/CFT/WMD reasons during reporting period
      def a3414
        clients_kept
          .where.not(relationship_end_reason: [nil, ""])
          .where(relationship_ended_at: Date.new(year, 1, 1)..Date.new(year, 12, 31))
          .count
      end

      # Q213: Terminations due to client attributes/activities/deficiencies
      def a3416
        clients_kept
          .where(relationship_end_reason: "AML_CONCERN")
          .where(relationship_ended_at: Date.new(year, 1, 1)..Date.new(year, 12, 31))
          .count
      end

      # === Section 3 Comments ===

      # Q214: Has comments on inherent risk section?
      def a3701a
        setting_value("inherent_risk_section_comments").present? ? "Oui" : "Non"
      end

      # Q215: Inherent risk section comment text
      def a3701
        setting_value("inherent_risk_section_comments")
      end

      # === ID Verification and Records ===

      # Records other individual info when operation performed by individual?
      def ac1629
        setting_value("records_other_individual_info")
      end

      # Other client info details
      def ac1630
        setting_value("other_client_info_details")
      end

      # CDD elements not collected
      def ac1602
        setting_value("cdd_elements_not_collected")
      end

      # === High-Risk CDD Frequency ===

      # High-risk sales/purchase client CDD frequency
      def ac1616b
        setting_value("high_risk_cdd_frequency")
      end

      # High-risk rental client CDD frequency
      def ac1616a
        setting_value("high_risk_rental_cdd_frequency")
      end

      # Has additional measures for high-risk clients?
      def ac1618
        setting_value("has_additional_high_risk_measures")
      end

      # Additional high-risk measures details
      def ac1619
        setting_value("additional_high_risk_measures_details")
      end

      # Third-party CDD difficulties?
      def ac1622a
        setting_value("has_third_party_cdd_difficulties")
      end

      # Third-party CDD difficulties details
      def ac1622b
        setting_value("third_party_cdd_difficulties_details")
      end

      # Virtual asset BO verification method
      def ac1621
        setting_value("virtual_asset_bo_verification_method")
      end

      # === SAR (Suspicious Activity Reports) ===

      # C1: Total employees (headcount) + non-salaried partners/owners
      # Same question as a3301
      def ac1102a
        setting_value("total_employees")&.to_i
      end

      # C2: Total FTE employees + non-salaried partners/owners
      def ac1102
        setting_value("total_employees_fte")&.to_i
      end

      # Monthly compliance hours
      def ac1101z
        setting_value("monthly_compliance_hours")
      end

      # === Board and Compliance ===

      # Has board of directors and/or senior management?
      def ac114
        setting_value("has_board_or_senior_management")
      end

      # Has compliance department?
      def ac1106
        setting_value("has_compliance_department")
      end

      # === Cash Operations ===

      # Conducts cash operations with clients?
      def ac11401
        setting_value("conducts_cash_operations")
      end

      # Has specific AML controls for cash operations?
      def ac11402
        setting_value("has_cash_aml_controls")
      end

      # Cash controls description
      def ac11403
        setting_value("cash_controls_description")
      end

      # === STR Reports ===

      # Filed STR reports with FIU in period?
      def ac11501b
        organization.str_reports.kept.for_year(year).exists? ? "Oui" : "Non"
      end

      # Terrorism financing STR count
      def ac11502
        setting_value("str_terrorism_financing_count")&.to_i
      end

      # Money laundering STR count
      def ac11504
        setting_value("str_money_laundering_count")&.to_i
      end

      # Strengthened internal controls for STR reporting?
      def ac11508
        setting_value("strengthened_internal_controls")
      end

      # === AML Training ===

      # Directors received AML training in period?
      def ac1501
        setting_value("directors_received_aml_training")
      end

      # Staff received AML training in period?
      def ac1503b
        setting_value("staff_received_aml_training")
      end

      # Total employees trained on AML
      def ac1506
        setting_value("employees_trained_aml_count")&.to_i
      end

      # Is entity part of a group?
      def ac1518a
        setting_value("is_part_of_group")
      end

      # === AML Policies ===

      # Policies approved by board?
      def ac1202
        setting_value("policies_approved_by_board")
      end

      # Policies distributed to staff?
      def ac1203
        setting_value("policies_distributed_to_staff")
      end

      # Policies known by staff?
      def ac1204
        setting_value("policies_known_by_staff")
      end

      # Policies updated this year?
      def ac1205
        setting_value("policies_updated_this_year")
      end

      # Policies last updated date
      def ac1206
        setting_value("policies_last_updated_date")
      end

      # Systematic policy change tracking?
      def ac1207
        setting_value("systematic_policy_change_tracking")
      end

      # Has group-wide AML program?
      def ac1209b
        setting_value("has_group_aml_program")
      end

      # Group program Monaco compliant?
      def ac1209c
        setting_value("group_program_monaco_compliant")
      end

      # Compliance policies author
      def ac1208
        setting_value("compliance_policies_author")
      end

      # Self-assessed AML procedures?
      def ac1209
        setting_value("self_assessed_aml_procedures")
      end

      # === Board and Management ===

      # Board demonstrates AML responsibility?
      def ac1301
        setting_value("board_demonstrates_aml_responsibility")
      end

      # Board receives regular AML reports?
      def ac1302
        setting_value("board_receives_aml_reports")
      end

      # Board addresses AML gaps?
      def ac1303
        setting_value("board_addresses_aml_gaps")
      end

      # Management approves high-risk clients?
      def ac1304
        setting_value("management_approves_high_risk_clients")
      end

      # === AML Violations ===

      # Had AML violations in last 5 years?
      def ac1401
        setting_value("had_aml_violations_5_years")
      end

      # AML violation count in last 5 years
      def ac1402
        setting_value("aml_violation_count_5_years")&.to_i
      end

      # AML violation details
      def ac1403
        setting_value("aml_violation_details")
      end

      # === Controls Section Comments ===

      # C104: Has comments on controls section?
      def ac116a
        setting_value("controls_section_comments").present? ? "Oui" : "Non"
      end

      # C105: Controls section comment text
      def ac11601
        setting_value("controls_section_comments")
      end

      # === Sanctions and Financial Screening ===

      # Policies cover targeted financial sanctions?
      def ac11201
        setting_value("policies_cover_targeted_financial_sanctions")
      end

      # Checks national asset freeze list? → CRM capability (moved to Survey::CrmCapabilities)

      # === PEP Screening ===

      # PEP identification measures
      def ac11302
        setting_value("pep_identification_measures")
      end

      # PEP additional procedures
      def ac11303
        setting_value("pep_additional_procedures")
      end

      # Continuous PEP screening? → CRM capability (moved to Survey::CrmCapabilities)

      # All PEP relationships considered high risk?
      def ac11307
        setting_value("all_pep_relationships_high_risk")
      end

      # === Terrorism/Proliferation Declarations ===

      # DBT terrorism financing declaration count
      def ac12236
        setting_value("dbt_terrorism_financing_declarations")&.to_i
      end

      # DBT WMD proliferation declaration count
      def ac12237
        setting_value("dbt_wmd_proliferation_declarations")&.to_i
      end

      # Identified terrorism or proliferation financing?
      def ac12333
        setting_value("identified_terrorism_or_proliferation")
      end
    end
  end
end
