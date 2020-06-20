module FatFreeCrm

  class FacilityFacilityCase < ActiveRecord::Base

    belongs_to :facility, class_name: "::FatFreeCrm::Contact" 
    belongs_to :facility_case, class_name: "::FatFreeCrm::FacilityCase"

    has_many   :contact_exposure_cases

    belongs_to :contact_elicitation_investigation, class_name: "::FatFreeCrm::investigations::ContactElicitationInvestigation"

    has_one    :facility_exposure_detail, class_name: "::FatFreeCrm::Exposures::FacilitySimpleExposure"
  
    has_paper_trail versions: {class_name: "FatFreeCrm::Version"}

  end
end