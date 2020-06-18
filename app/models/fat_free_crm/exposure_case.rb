module FatFreeCrm
  class ExposureCase < ActiveRecord::Base
    include FatFreeCrm::Fields

  	belongs_to :user
    belongs_to :campaign
  	belongs_to :assignee, class_name: "::FatFreeCrm::User", foreign_key: :assigned_to

    belongs_to :index_case, class_name: "::FatFreeCrm::IndexCase"

    belongs_to :contact, class_name: "::FatFreeCrm::Contact"
    belongs_to :facility, class_name: "::FatFreeCrm::Facility"

    has_many :tasks, as: :asset, dependent: :destroy # , :order => 'created_at DESC'
    has_many :emails, as: :mediator

    serialize :subscribed_users, Set

    scope :state, lambda { |filters|
      where('stage IN (?)' + (filters.delete('other') ? ' OR stage IS NULL' : ''), filters)
    }

    scope :created_by,  ->(user) { where("#{table_name}.user_id = ?", user.id) }
    scope :assigned_to, ->(user) { where("#{table_name}.assigned_to = ?", user.id) }

    scope :interviewed, -> { where("#{table_name}.stage = 'interviewed'") }
    scope :closed,      -> { where("#{table_name}.stage = 'closed'") }
    scope :not_closed,  -> { where("#{table_name}.stage != 'not_closed'") }
    scope :pipeline,    -> { where("#{table_name}.stage IS NULL OR (#{table_name}.stage != 'interviewed' AND #{table_name}.stage != 'closed')") }
    scope :unassigned,  -> { where("#{table_name}.assigned_to IS NULL") }
    scope :priority,      -> { select('*, amount*probability') }


    # Search by name OR id
    scope :text_search, lambda { |query|
      if query.match?(/\A\d+\z/)
        where('upper(name) LIKE upper(:name) OR opportunities.id = :id', name: "%#{query}%", id: query)
      else
        ransack('name_cont' => query).result
      end
    }

    scope :visible_on_dashboard, lambda { |user|
      # Show opportunities which either belong to the user and are unassigned, or are assigned to the user and haven't been closed (won/lost)
      where("(#{table_name}.user_id = :user_id AND #{table_name}.assigned_to IS NULL) OR #{table_name}.assigned_to = :user_id", user_id: user.id).where("#{table_name}.stage != 'interviewed'").where("#{table_name}.stage != 'closed'")
    }

    scope :by_window_closes_at, -> { order(:window_closes_at) }
    scope :by_priority,         -> { order("#{table_name}.priority DESC") }

  	uses_user_permissions
    acts_as_commentable
    uses_comment_extensions
    exportable
    acts_as_taggable_on :tags
    has_paper_trail versions: {class_name: "FatFreeCrm::Version"}, ignore: [:subscribed_users]

    has_fields
    exportable
    sortable by: ["name ASC", "amount DESC", "amount*probability DESC", "probability DESC", "closes_on ASC", "created_at DESC", "updated_at DESC"], default: "created_at DESC"

    has_ransackable_associations %w[account contacts tags campaign activities emails comments]
    ransack_can_autocomplete

    after_create :increment_exposures_count
    after_destroy :decrement_exposures_count

    private

    # Make sure at least one user has been selected if the contact is being shared.
    #----------------------------------------------------------------------------
    def users_for_shared_access
      errors.add(:access, :share_opportunity) if self[:access] == "Shared" && permissions.none?
    end

    #----------------------------------------------------------------------------
    def increment_opportunities_count
      Campaign.increment_counter(:opportunities_count, campaign_id) if campaign_id
    end

    #----------------------------------------------------------------------------
    def decrement_opportunities_count
      Campaign.decrement_counter(:opportunities_count, campaign_id) if campaign_id
    end

    ActiveSupport.run_load_hooks(:fat_free_crm_opportunity, self)

  end
end