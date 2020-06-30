module FatFreeCrm
  module Investigations

    class ContactElicitationInvestigation < ApplicationRecord

      belongs_to :index_case, class_name: "::FatFreeCrm::IndexCase"
      belongs_to :facility_case, class_name: "::FatFreeCrm::FacilityCase"
      belongs_to :contact_representative, class_name: "::FatFreeCrm::Contact"

      has_many   :contact_exposure_cases, class_name: "::FatFreeCrm::ContactExposureCase"
      has_many   :facility_facility_cases, class_name: "::FatFreeCrm::FacilityFacilityCase"

      has_paper_trail versions: {class_name: "FatFreeCrm::Version"}
      acts_as_commentable
      uses_comment_extensions

      accepts_nested_attributes_for :contact_exposure_cases,  allow_destroy: true
      accepts_nested_attributes_for :facility_facility_cases,  allow_destroy: true
    end
  end
end
