module FatFreeCrm

  class FacilityFacilityCase < ActiveRecord::Base

    belongs_to :facility, class_name: "::FatFreeCrm::Facility"
    belongs_to :facility_case, class_name: "::FatFreeCrm::FacilityCase"
    belongs_to :contact_elicitation_investigation, class_name: "::FatFreeCrm::investigations::ContactElicitationInvestigation"
    has_one    :facility_exposure_detail, class_name: "::FatFreeCrm::Exposures::FacilitySimpleExposure"
  
    has_paper_trail versions: {class_name: "FatFreeCrm::Version"}

    accepts_nested_attributes_for :facility_exposure_detail,  allow_destroy: true

  end
end