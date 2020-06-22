module FatFreeCrm

  class ContactIndexCase < ActiveRecord::Base

    belongs_to :contact, class_name: "::FatFreeCrm::Contact"
    belongs_to :index_case, class_name: "::FatFreeCrm::IndexCase"
  
    has_paper_trail versions: {class_name: "FatFreeCrm::Version"}

  end
end