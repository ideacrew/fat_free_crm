# frozen_string_literal: true

module FatFreeCrm
  class ExposureObserver < ActiveRecord::Observer
    observe :"FatFreeCrm::Exposure"

    def after_create(item)
      send_notification_to_manager(item) if item.contact.present? && item.index_case.contact.present?
    end

    private

    def send_notification_to_manager(item)
      UserMailer.exposure_notification_to_manager(item).deliver_now
    end

    ActiveSupport.run_load_hooks(:fat_free_crm_index_case_observer, self)
  end
end
