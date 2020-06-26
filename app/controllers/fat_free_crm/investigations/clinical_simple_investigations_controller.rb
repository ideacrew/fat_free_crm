# frozen_string_literal: true

module FatFreeCrm
  module Investigations
    class ClinicalSimpleInvestigationsController < FatFreeCrm::EntitiesController

      def generate_osha
        osha_form = IndexCases::Osha::Form301::Serialize.new.call(investigation: @clinical_simple_investigation)
       
        if osha_form.success?
          send_file osha_form.success, filename: "osha_301.xlsx", disposition: 'attachment'
        else
          redirect_to index_cases_path, flash: { error: "OSHA-301 generation failed due to #{osha_form.failure.errors.to_h}" }
        end
      end
    end
  end
end
