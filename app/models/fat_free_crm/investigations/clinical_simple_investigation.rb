module FatFreeCrm
  module Investigations

    class ClinicalSimpleInvestigation < ApplicationRecord

      belongs_to :index_case, class_name: "::FatFreeCrm::IndexCase"
      belongs_to :exposure_case, class_name: "::FatFreeCrm::ExposureCase"
      belongs_to :contact_representative, class_name: "::FatFreeCrm::Contact"
      belongs_to :health_care_provider_contact, class_name: "::FatFreeCrm::Contact"
      
      has_paper_trail versions: {class_name: "FatFreeCrm::Version"}
      
      acts_as_commentable
      uses_comment_extensions

      def health_event
        [:hcp_consult_event, :hospitalized_event, :emergency_room_event, :death_event, :none_of_the_above].detect do |event_name|
          self.send(event_name) == true
        end
      end

      def health_event=(value)
        [:hcp_consult_event, :hospitalized_event, :emergency_room_event, :death_event, :none_of_the_above].each do |event_name|
          if event_name.to_s == value
            self.send "#{event_name}=", true
          else
            self.send "#{event_name}=", false
          end
        end
      end
    end
  end
end
