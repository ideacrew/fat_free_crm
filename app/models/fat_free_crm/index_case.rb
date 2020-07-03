# Attributes
# id: nil
# user_id: nil,
# assigned_to: nil,
# access: nil,
# source: nil,
# background_info: nil,
# created_at: nil,
# updated_at: nil,
# category: nil,
# opportunity_id: nil,
# window_start_date: nil,
# window_end_date: nil,
# opened_at: nil,
# closed_at: nil,
# projected_return_date: nil,
# contact_id: nil,
# subscribed_users: #<Set: {}>,
# case_number: nil,
# tag_list: nil> 

module FatFreeCrm
  class IndexCase < ActiveRecord::Base
  	belongs_to :user
  	belongs_to :assignee, class_name: "::FatFreeCrm::User", foreign_key: :assigned_to

 		belongs_to :opportunity, class_name: "::FatFreeCrm::Opportunity"
 		has_many :tasks, as: :asset, dependent: :destroy # , :order => 'created_at DESC'
    has_many :emails, as: :mediator

    has_one    :contact_index_case, class_name: "::FatFreeCrm::ContactIndexCase"
    has_one    :contact, :through => :contact_index_case

    has_one  :index_case_investigation, dependent: :destroy, class_name: "::FatFreeCrm::Investigations::IndexCaseSimpleInvestigation"
    has_one  :contact_elicitation_investigation, dependent: :destroy, class_name: "::FatFreeCrm::Investigations::ContactElicitationInvestigation"
    has_many :clinical_investigations, dependent: :destroy, class_name: "::FatFreeCrm::Investigations::ClinicalSimpleInvestigation"

    serialize :subscribed_users, Set
    enum work_related: { unknown: 'Unknown', likely: 'Likely', unlikely: 'Unlikely'}

    accepts_nested_attributes_for :contact_index_case,  allow_destroy: true
    accepts_nested_attributes_for :clinical_investigations,  allow_destroy: true
    accepts_nested_attributes_for :index_case_investigation,  allow_destroy: true
    accepts_nested_attributes_for :contact_elicitation_investigation,  allow_destroy: true

  	uses_user_permissions
    acts_as_commentable
    uses_comment_extensions
    exportable
    acts_as_taggable_on :tags
    has_paper_trail versions: {class_name: "FatFreeCrm::Version"}, ignore: [:subscribed_users]

    has_ransackable_associations %w[contacts opportunity tags exposures emails investigations comments tasks]
    ransack_can_autocomplete

    sortable by: ["created_at DESC", "updated_at DESC", "case_number DESC"], default: "created_at DESC"
    scope :text_search, ->(query) { ransack('name_or_email_cont' => query).result }
  
    # Attach given attachment to the index_case if it hasn't been attached already.
    #----------------------------------------------------------------------------
    def attach!(attachment)
      send(attachment.class.name.demodulize.tableize) << attachment unless send("#{attachment.class.name.demodulize.downcase}_ids").include?(attachment.id)
    end

    # Discard given attachment from the index_case.
    #----------------------------------------------------------------------------
    def discard!(attachment)
      if attachment.is_a?(Task)
        attachment.update_attribute(:asset, nil)
      else # Contacts, Opportunities
        send(attachment.class.name.demodulize.tableize).delete(attachment)
      end
    end
  end
end
