class RemoveFacilityFacilityCaseOnContactExposureCase < ActiveRecord::Migration[4.2]
  def change
    remove_column :fat_free_crm_contact_exposure_cases, :facility_facility_case_id
  end
end