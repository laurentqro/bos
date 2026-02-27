# frozen_string_literal: true

class Survey
  module Fields
    module DistributionRisk
      # Q168 — a3101: Does entity use local third parties for CDD?
      # Type: enum (Oui/Non) — settings-based
      def a3101
        setting_value_for("uses_local_third_party_cdd")
      end

      # Q169 — a3102: Clients with local third-party CDD, by primary nationality (dimensional)
      # Type: xbrli:integerItemType — dimensional by country, conditional on a3101
      def a3102
        return nil unless a3101 == "Oui"

        country_sql = "CASE WHEN clients.client_type = 'NATURAL_PERSON' " \
          "THEN clients.nationality ELSE clients.incorporation_country END"

        organization.clients.kept
          .where(third_party_cdd: true, third_party_cdd_type: "LOCAL")
          .where("#{country_sql} IS NOT NULL")
          .group(Arel.sql(country_sql))
          .count
      end
    end
  end
end
