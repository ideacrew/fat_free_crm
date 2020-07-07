module FatFreeCrm
  module Investigations

    class ExposureCaseSimpleInvestigation < ApplicationRecord

      belongs_to :exposure_case, class_name: "::FatFreeCrm::ExposureCase"
      belongs_to :contact_representative, class_name: "::FatFreeCrm::Contact"

      has_paper_trail versions: {class_name: "FatFreeCrm::Version"}
      acts_as_commentable
      uses_comment_extensions

      def self_quarantine
        if need_assistance_to_self_quarantine
          :need_assistance_to_self_quarantine
        else
          :can_self_quarantine
        end
      end
    end
  end
end
