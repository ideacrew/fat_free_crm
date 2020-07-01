# frozen_string_literal: true

module FatFreeCrm
  class ContactExposureCaseObserver < ActiveRecord::Observer
    observe :"::FatFreeCrm::ContactExposureCase"

    def after_create(item)
      create_exposure_case(item)
    end

    private

    # can they change contact once contact exposure is created?? we should block it
    def create_exposure_case(contact_exposure_case)
      return if contact_exposure_case.exposure_case
      contact_exposure_case.build_exposure_case({
        investigation_kind: CovidMostRegistry[:case_investigation_kind].item,
        opened_at: Time.now
      }).save
    end

    ActiveSupport.run_load_hooks(:contact_exposure_case_observer, self)
  end
end
