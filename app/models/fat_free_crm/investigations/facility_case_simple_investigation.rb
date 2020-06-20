module FatFreeCrm
  module Investigations

    class IndexCaseSimpleInvestigation < ApplicationRecord

      belongs_to :facility_case, class_name: "::FatFreeCrm::FacilityCase"

      has_paper_trail versions: {class_name: "FatFreeCrm::Version"}
      acts_as_commentable
      uses_comment_extensions
    end
  end
end
