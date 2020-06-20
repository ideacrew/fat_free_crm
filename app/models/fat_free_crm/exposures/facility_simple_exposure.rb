module FatFreeCrm
  module Exposures

    class FacilitySimpleExposure < ApplicationRecord
    	has_paper_trail versions: {class_name: "FatFreeCrm::Version"}
    end
  end
end