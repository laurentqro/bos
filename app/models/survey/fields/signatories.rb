# frozen_string_literal: true

# Tab 5: Signatories
# Field methods for signatory information and entity details
#
# Fields cover:
# - Entity information (legal form, registration)
# - Business profile (services, revenue)
# - Office locations
# - Employee information
# - Submission status
#
class Survey
  module Fields
    module Signatories
      extend ActiveSupport::Concern
      include Helpers

      private

      # === Enhanced Due Diligence Statistics ===

      # C67: Total clients with enhanced due diligence (EDD) at onboarding
      # Counts clients with REINFORCED DD level who became clients during the reporting year
      def ac1701
        clients_kept
          .where(due_diligence_level: "REINFORCED")
          .where(became_client_at: Date.new(year, 1, 1)..Date.new(year, 12, 31))
          .count
      end

      # C68: Total clients with enhanced due diligence during relationship
      # All clients currently with REINFORCED DD level (reviewed during the period)
      def ac1702
        clients_kept
          .where(due_diligence_level: "REINFORCED")
          .count
      end

      # C69: Percentage of clients with enhanced due diligence
      # i.e. number of enhanced due diligence clients / total number of clients
      def ac1703
        total = clients_kept.count
        return 0 if total.zero?

        reinforced = clients_kept.where(due_diligence_level: "REINFORCED").count
        (reinforced.to_f / total * 100).round(2)
      end

      # === Business Profile ===

      def ac1636
        setting_value("property_management") || "Non"
      end

      def ac1637
        setting_value("ancillary_services")
      end

      def ac1640a
        setting_value("legal_services")
      end

      # === Risk Classification ===

      # C81: How many AML/CFT risk levels does the entity have?
      # Derived from system constant (LOW/MEDIUM/HIGH)
      def ac1801
        AmsfConstants::RISK_LEVELS.size
      end

      # C51: Total unique clients (repeat of a1101 — uses clients_kept scope)
      def ac1611
        clients_kept.count
      end

      # High-risk clients count
      def ac1802
        clients_kept.where(risk_level: "high").count
      end

      def ac1806
        setting_value("operating_expenses") || "Non"
      end

      def ac1610
        setting_value("annual_transaction_volume") || "Non"
      end

      # === Simplified Due Diligence ===

      # C52a: Applied simplified DD in period?
      def ac1612a
        clients_kept.where(due_diligence_level: "SIMPLIFIED").exists? ? "Oui" : "Non"
      end

      # C52: Total clients under simplified due diligence
      def ac1612
        clients_kept.where(due_diligence_level: "SIMPLIFIED").count
      end

      # === Office Information ===

      def ac1812
        setting_value("offices_count") || "Non"
      end

      def ac1813
        setting_value("monaco_offices")
      end

      def ac1814w
        setting_value("overseas_offices") || "Non"
      end

      # === Employee Information ===

      def ac1807
        setting_value("employee_count")
      end

      def ac1811
        setting_value("licensed_agents") || "Non"
      end

      def ac1904
        setting_value("last_external_audit")
      end

      # === Submission Status ===

      def as1
        setting_value("status_1")
      end

      def as2
        setting_value("status_2")
      end

      def aincomplete
        setting_value("survey_incomplete")
      end

      # === Legal Entity Status ===

      # Q37: Monaco legal entity clients grouped by legal_entity_type
      # Returns dimensional hash of XBRL member code => count
      def amles
        raw_counts = clients_kept
          .legal_entities
          .where(incorporation_country: "MC")
          .where.not(legal_entity_type: [nil, ""])
          .group(:legal_entity_type)
          .count

        raw_counts.each_with_object({}) do |(type, count), result|
          xbrl_key = AmsfConstants::LEGAL_ENTITY_TYPE_TO_XBRL.fetch(type)
          result[xbrl_key] = (result[xbrl_key] || 0) + count
        end
      end
    end
  end
end
