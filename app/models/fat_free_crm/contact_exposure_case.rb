module FatFreeCrm

  class ContactExposureCase < ActiveRecord::Base

    belongs_to :contact, class_name: "::FatFreeCrm::Contact"
    belongs_to :exposure_case, class_name: "::FatFreeCrm::ExposureCase"
    belongs_to :notifying_contact, class_name: "::FatFreeCrm::Contact"
    belongs_to :contact_elicitation_investigation, class_name: "::FatFreeCrm::Investigations::ContactElicitationInvestigation"
    has_one    :contact_exposure_detail, dependent: :destroy, class_name: "::FatFreeCrm::Exposures::ContactSimpleExposure"
  
    has_paper_trail versions: {class_name: "FatFreeCrm::Version"}

    accepts_nested_attributes_for :contact_exposure_detail,  allow_destroy: true
    
    default_scope { order(created_at: :asc) }

  end
end