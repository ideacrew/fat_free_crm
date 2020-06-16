# frozen_string_literal: true
# == Schema Information
#
# Table name: exposures
#  index_case_id      :integer
#  started_at         :datetime
#  ended_at           :datetime
#  level              :string
#  contact_id         :integer
#  facility_id        :integer
#  used_mask          :bool
#  user_id            :integer
#  assigned_to_id     : integer
#  subscribed_users
#  created_at         :datetime
#  updated_at         :datetime

module FatFreeCrm
  class Exposure < ActiveRecord::Base
  	belongs_to :user
  	belongs_to :assignee, class_name: "::FatFreeCrm::User", foreign_key: :assigned_to
    belongs_to :index_case, class_name: "::FatFreeCrm::IndexCase"
    belongs_to :contact, class_name: "::FatFreeCrm::Contact"
    belongs_to :facility, class_name: "::FatFreeCrm::Facility"

    has_many :emails, as: :mediator

    serialize :subscribed_users, Set

  	uses_user_permissions
    acts_as_commentable
    uses_comment_extensions
    exportable
    acts_as_taggable_on :tags
    has_paper_trail versions: {class_name: "FatFreeCrm::Version"}, ignore: [:subscribed_users]

  end
end