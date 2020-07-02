module FatFreeCrm
  class FacilityCase < ActiveRecord::Base

  	belongs_to :user
  	belongs_to :assignee, class_name: "::FatFreeCrm::User", foreign_key: :assigned_to

    has_one    :facility_facility_case, class_name: "::FatFreeCrm::FacilityFacilityCase"
    has_one    :facility, :through => :facility_facility_case

 		has_many   :tasks, as: :asset, dependent: :destroy # , :order => 'created_at DESC'

    has_one    :facility_case_investigation, class_name: "::FatFreeCrm::Investigations::FacilityCaseSimpleInvestigation"
    has_one    :contact_elicitation_investigation, class_name: "::FatFreeCrm::Investigations::ContactElicitationInvestigation"

    serialize  :subscribed_users, Set

  	uses_user_permissions
    acts_as_commentable
    uses_comment_extensions
    exportable
    acts_as_taggable_on :tags
    has_paper_trail versions: {class_name: "FatFreeCrm::Version"}, ignore: [:subscribed_users]

    has_ransackable_associations %w[opportunity]
    ransack_can_autocomplete

  	sortable by: ["created_at DESC", "updated_at DESC"], default: "created_at DESC"

  end
end