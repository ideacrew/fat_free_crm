module FatFreeCrm
  module Exposures

    class ContactSimpleExposure < ApplicationRecord

    	belongs_to :contact_exposure_case, class_name: "::FatFreeCrm::ContactExposureCase"

    	has_paper_trail versions: {class_name: "FatFreeCrm::Version"}
    end
  end
end
