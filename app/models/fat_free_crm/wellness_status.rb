module FatFreeCrm

  class WellnessStatus < ActiveRecord::Base

    belongs_to :contact, class_name: "::FatFreeCrm::Contact"
    has_many   :attestations, dependent: :destroy
  
    has_paper_trail versions: {class_name: "FatFreeCrm::Version"}

    accepts_nested_attributes_for :attestations,  allow_destroy: true
    
    default_scope { order(created_at: :asc) }

  end
end