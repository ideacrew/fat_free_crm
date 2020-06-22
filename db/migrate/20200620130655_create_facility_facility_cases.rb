class CreateFacilityFacilityCases < ActiveRecord::Migration[6.0]

  def change
    
    create_table :fat_free_crm_facility_facility_cases do |t|

      t.references :facility
      t.references :faciltiy_case
      t.references :contact_elicitation_investigation, index: {:name => "facility_facility_cases_contact_elicitation_investigation_id"}

      t.string     :case_id
      t.integer    :investigation_priority
      t.datetime   :window_opens_at
      t.datetime   :window_closes_at
      t.datetime   :deleted_at

      t.timestamps
    end
  end
end