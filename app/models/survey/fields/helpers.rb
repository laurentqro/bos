# frozen_string_literal: true

class Survey
  module Fields
    module Helpers
      private

      def setting_value_for(key)
        organization.settings.find_by(key: key)&.value
      end
    end
  end
end
