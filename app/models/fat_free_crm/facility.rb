module FatFreeCrm
  class Facility < ApplicationRecord
  	belongs_to :user
    has_one :address, dependent: :destroy, as: :addressable, class_name: "Address" # advanced search uses this

    has_many :assignments
    has_many :levels
    has_and_belongs_to_many :accounts
    has_many :contacts, through: :accounts

    has_many :facility_facility_cases, dependent: :destroy
    has_many :facility_cases, through: :facility_facility_cases

    scope :contact_contact, -> { self.accounts.sum(&:contact_count) }

    uses_user_permissions
    acts_as_commentable
    uses_comment_extensions
    exportable
    acts_as_taggable_on :tags
    has_paper_trail versions: {class_name: "FatFreeCrm::Version"}, ignore: [:subscribed_users]

    has_ransackable_associations %w[accounts addresses comments]
    ransack_can_autocomplete

    enum status: {open: 'Open', close: 'Close'}

  	sortable by: ["name ASC", "rating DESC", "created_at DESC", "updated_at DESC"], default: "created_at DESC"

    accepts_nested_attributes_for :address, allow_destroy: true, reject_if: proc { |attributes| Address.reject_address(attributes) }
    accepts_nested_attributes_for :levels, allow_destroy: true

    scope :text_search, ->(query) { ransack('name_cont' => query).result }

    validates_presence_of :name
  end
end