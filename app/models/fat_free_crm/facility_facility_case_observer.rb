# frozen_string_literal: true

module FatFreeCrm
  class FacilityFacilityCaseObserver < ActiveRecord::Observer
    observe :"::FatFreeCrm::FacilityFacilityCase"

    def after_create(item)
      create_facility_case(item)
    end

    private

    # can they change contact once contact exposure is created?? we should block it
    def create_facility_case(facility_facility_case)
      return if facility_facility_case.facility_case
      facility_facility_case.build_facility_case({
        investigation_kind: CovidMostRegistry[:case_investigation_kind].item,
        opened_at: Time.now
      }).save
    end

    ActiveSupport.run_load_hooks(:facility_facility_case_observer, self)
  end
end
