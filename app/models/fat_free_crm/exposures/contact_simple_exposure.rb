module FatFreeCrm
  module Exposures

    class ContactSimpleExposure < ApplicationRecord

    	belongs_to :contact_exposure_case, class_name: "::FatFreeCrm::ContactExposureCase"

    	# index_case
        # contact,                 Contacts::Contact.optional.meta(omittable: true)
        # facility,                Facilities::Facility.optional.meta(omittable: true)

    	has_paper_trail versions: {class_name: "FatFreeCrm::Version"}

    end
  end
end
