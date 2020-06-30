class RemoveGuidanceOnInvestigations < ActiveRecord::Migration[4.2]
  def change
    remove_column :fat_free_crm_investigations_clinical_simple_investigations, :guidance
    remove_column :fat_free_crm_investigations_exposure_case_simple_investigations, :guidance
    remove_column :fat_free_crm_investigations_index_case_simple_investigations, :guidance
    remove_column :fat_free_crm_investigations_facility_case_simple_investigations, :guidance
    remove_column :fat_free_crm_exposures_contact_simple_exposures, :guidance
  end
end