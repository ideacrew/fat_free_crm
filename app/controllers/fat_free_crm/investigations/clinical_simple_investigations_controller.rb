# frozen_string_literal: true

module FatFreeCrm
  module Investigations
    class ClinicalSimpleInvestigationsController < FatFreeCrm::EntitiesController
      include ActionView::Helpers::TagHelper

      def generate_osha
        osha_form = IndexCases::Osha::Form301::Serialize.new.call(investigation: @clinical_simple_investigation)
       
        if osha_form.success?
          send_file osha_form.success, filename: "osha_301.xlsx", disposition: 'attachment'
        else
          redirect_to index_cases_path, flash: { error: "OSHA-301 generation failed due to " + format_errors(osha_form.failure.errors) }
        end
      end

      private


      def format_errors(errors)
        content_tag(:ul, extract_errors(errors.to_h).map do |msg|
          content_tag(:li, msg)
        end.join.html_safe).html_safe
      end

      def extract_errors(errors, parent_key = nil)
        messages = []

        errors.each do |key, value|
          if value.is_a?(Hash)
            messages += extract_errors(value, key)
          else
            messages << (parent_key.present? ? "#{parent_key} #{key} #{value.first}" : "#{key} #{value.first}")
          end
        end

        return messages.map(&:humanize)
      end
    end
  end
end
