module FatFreeCrm

  class Attestation < ActiveRecord::Base

    belongs_to :wellness_status
    has_many   :declarations, dependent: :destroy
  
    has_paper_trail versions: {class_name: "FatFreeCrm::Version"}

    accepts_nested_attributes_for :declarations,  allow_destroy: true
    
    default_scope { order(created_at: :asc) }

  end
end