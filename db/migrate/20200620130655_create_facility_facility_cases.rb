class CreateFacilityFacilityCases < ActiveRecord::Migration[6.0]

  def change
    create_table :fat_free_crm_facility_facility_cases do |t|
      t.references :facility
      t.references :facility_case
      t.references :contact_elicitation_investigation, index: {:name => "facility_facility_cases_contact_elicitation_investigation_id"}
    
      t.datetime   :deleted_at
      t.timestamps
    end
  end
end