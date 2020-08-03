module FatFreeCrm

  class Declaration < ActiveRecord::Base

    belongs_to :attestation
    has_paper_trail versions: {class_name: "FatFreeCrm::Version"}

    
    default_scope { order(created_at: :asc) }

  end
end