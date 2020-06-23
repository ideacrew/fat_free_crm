module FatFreeCrm
  module Investigations

    class ClinicalSimpleInvestigation < ApplicationRecord

      belongs_to :index_case, class_name: "::FatFreeCrm::IndexCase"
      belongs_to :exposure_case, class_name: "::FatFreeCrm::ExposureCase"
      belongs_to :health_care_provider, class_name: "::FatFreeCrm::Acount"
      belongs_to :contact_representative, class_name: "::FatFreeCrm::Contact"
      
      has_paper_trail versions: {class_name: "FatFreeCrm::Version"}
      
      acts_as_commentable
      uses_comment_extensions
    end
  end
end
