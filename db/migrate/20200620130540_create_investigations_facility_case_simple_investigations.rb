class CreateInvestigationsFacilityCaseSimpleInvestigations < ActiveRecord::Migration[6.0]
  def change
    create_table :fat_free_crm_investigations_facility_case_simple_investigations do |t|
      t.references :facility_case, index: {:name => "facility_case_simple_investigations_facility_case_id"}
      t.references :contact_representative, index: {:name => "facility_case_simple_investigations_contact_representative_id"}
      
      t.string   :contact_representative_relationship_kind
      t.datetime :interview_at
      t.string   :guidance
      t.datetime :deleted_at

      t.timestamps
    end
  end
end