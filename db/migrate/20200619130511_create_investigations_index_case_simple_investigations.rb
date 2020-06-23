class CreateInvestigationsIndexCaseSimpleInvestigations < ActiveRecord::Migration[6.0]
  def change
    create_table :fat_free_crm_investigations_index_case_simple_investigations do |t|
      t.references :index_case, index: {:name => "index_case_simple_investigations_index_case_id"}
      t.references :contact_representative, index: {:name => "exposure_case_simple_investigations_contact_representative_id"}

      t.boolean  :can_self_isolate
      t.boolean  :need_assistance_to_self_isolate
      t.datetime :interview_at
      t.datetime :onset_of_symptoms
      t.text     :symptoms, array: true, default: []
      t.string   :guidance
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
