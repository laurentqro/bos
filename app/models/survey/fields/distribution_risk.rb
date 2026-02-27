# frozen_string_literal: true

class Survey
  module Fields
    module DistributionRisk
      # Q168 — a3101: Does entity use local third parties for CDD?
      # Type: enum (Oui/Non) — settings-based
      def a3101
        setting_value_for("uses_local_third_party_cdd")
      end
    end
  end
end
