# frozen_string_literal: true

module FatFreeCrm
  module Investigations
    class ClinicalSimpleInvestigationsController < FatFreeCrm::EntitiesController

      def generate_osha
        osha_form = IndexCases::Osha::Form301::Serialize.new.call(investigation: @clinical_simple_investigation)

        send_file osha_form.success, filename: "osha_301.xlsx", disposition: 'attachment'
      end
    end
  end
end
