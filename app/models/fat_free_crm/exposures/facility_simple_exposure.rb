module FatFreeCrm
  module Exposures

    class FacilitySimpleExposure < ApplicationRecord

    	belongs_to :facility_facility_case, class_name: "::FatFreeCrm::FacilityFacilityCase"

    	has_paper_trail versions: {class_name: "FatFreeCrm::Version"}
    end
  end
end