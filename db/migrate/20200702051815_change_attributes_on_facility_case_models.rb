class ChangeAttributesOnFacilityCaseModels < ActiveRecord::Migration[6.0]
  def change
  	remove_column :fat_free_crm_exposures_facility_simple_exposures, :used_mask
  	remove_column :fat_free_crm_exposures_facility_simple_exposures, :contact_exposure_investigation_priority
    remove_column :fat_free_crm_investigations_facility_case_simple_investigations, :contact_representative_relationship_kind
    
    add_column :fat_free_crm_investigations_facility_case_simple_investigations, :case_reference, :string
  end
end