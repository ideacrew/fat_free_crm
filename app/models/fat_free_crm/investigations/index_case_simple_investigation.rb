module FatFreeCrm
  module Investigations

    class IndexCaseSimpleInvestigation < ApplicationRecord

      belongs_to :index_case, class_name: "::FatFreeCrm::IndexCase"
      belongs_to :contact_representative, class_name: "::FatFreeCrm::Contact"

      has_paper_trail versions: {class_name: "FatFreeCrm::Version"}
      acts_as_commentable
      uses_comment_extensions

      def self_isolate
		if need_assistance_to_self_isolate
          :need_assistance_to_self_isolate
        else
          :can_self_isolate
        end
      end

      def self_isolate=(value)
		[:need_assistance_to_self_isolate, :can_self_isolate].each do |attribute|
		  if attribute.to_s == value
            send "#{attribute}=", true
          else
            send "#{attribute}=", false
          end
        end
      end
    end
  end
end
