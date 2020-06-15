module FatFreeCrm
  class Assignment < ActiveRecord::Base
    belongs_to :facility, class_name: "FatFreeCrm::Facility"
    belongs_to :contact
    belongs_to :account
    belongs_to :level

    validates_presence_of :facility_id
    validates_presence_of :account_id
    validates_presence_of :contact_id

    def self.facility_class
      @@facility_class.constantize
    end

    scope :current, -> { where('end_on > ? OR end_on IS NULL', Date.today) }
  end
end
