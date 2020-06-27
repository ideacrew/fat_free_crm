module FatFreeCrm
  module Investigations

    class FacilityCaseSimpleInvestigation < ApplicationRecord

      belongs_to :facility_case, class_name: "::FatFreeCrm::FacilityCase"
      belongs_to :contact_representative, class_name: "::FatFreeCrm::Contact"

      has_paper_trail versions: {class_name: "FatFreeCrm::Version"}
      acts_as_commentable
      uses_comment_extensions
    end
  end
end
