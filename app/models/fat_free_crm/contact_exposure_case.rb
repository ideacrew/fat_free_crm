module FatFreeCrm

  class ContactExposureCase < ActiveRecord::Base

    belongs_to :contact, class_name: "::FatFreeCrm::Contact"
    belongs_to :exposure_case, class_name: "::FatFreeCrm::ExposureCase"
    belongs_to :facility_facility_case, class_name: "::FatFreeCrm::FacilityFacilityCase"
    belongs_to :contact_elicitation_investigation, class_name: "::FatFreeCrm::investigations::ContactElicitationInvestigation"
    
    has_one    :contact_exposure_detail, class_name: "::FatFreeCrm::Exposures::ContactSimpleExposure"
  
    has_paper_trail versions: {class_name: "FatFreeCrm::Version"}

  end
end