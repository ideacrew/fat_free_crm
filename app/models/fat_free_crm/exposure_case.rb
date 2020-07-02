module FatFreeCrm
  class ExposureCase < ActiveRecord::Base
    include FatFreeCrm::Fields

  	belongs_to :user
  	belongs_to :assignee, class_name: "::FatFreeCrm::User", foreign_key: :assigned_to

    has_one    :exposure_case_investigation, dependent: :destroy, class_name: "::FatFreeCrm::Investigations::ExposureCaseSimpleInvestigation"
    has_many   :clinical_investigations, dependent: :destroy, class_name: "::FatFreeCrm::Investigations::ClinicalSimpleInvestigation"

    has_one    :contact_exposure_case, class_name: "::FatFreeCrm::ContactExposureCase"
    has_one    :contact, :through => :contact_exposure_case

    has_many :emails, as: :mediator

    serialize :subscribed_users, Set

    # Search by name OR id
    scope :text_search, lambda { |query|
      if query.match?(/\A\d+\z/)
        where('upper(name) LIKE upper(:name) OR opportunities.id = :id', name: "%#{query}%", id: query)
      else
        ransack('name_cont' => query).result
      end
    }

    accepts_nested_attributes_for :contact_exposure_case,  allow_destroy: true
    accepts_nested_attributes_for :clinical_investigations,  allow_destroy: true
    accepts_nested_attributes_for :exposure_case_investigation,  allow_destroy: true

    scope :by_window_closes_at, -> { order(:window_closes_at) }
    scope :by_priority,         -> { order("#{table_name}.priority DESC") }
  	uses_user_permissions
    acts_as_commentable
    uses_comment_extensions
    acts_as_taggable_on :tags
    has_paper_trail versions: {class_name: "FatFreeCrm::Version"}, ignore: [:subscribed_users]
    has_fields
    exportable
    # sortable by: ["name ASC", "amount DESC", "amount*probability DESC", "probability DESC", "closes_on ASC", "created_at DESC", "updated_at DESC"], default: "created_at DESC"
    has_ransackable_associations %w[user assignee exposure_case_investigation clinical_investigations contact_exposure_case contact emails]
    ransack_can_autocomplete

    private
    # Make sure at least one user has been selected if the contact is being shared.
    #----------------------------------------------------------------------------
    def users_for_shared_access
      errors.add(:access, :share_opportunity) if self[:access] == "Shared" && permissions.none?
    end

    ActiveSupport.run_load_hooks(:fat_free_crm_opportunity, self)
  end
end