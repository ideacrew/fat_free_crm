class CreateInvestigationsIndexCaseSimpleInvestigations < ActiveRecord::Migration[6.0]
  def change
    create_table :fat_free_crm_investigations_index_case_simple_investigations do |t|
      t.references :index_case, index: {:name => "index_case_simple_investigations_index_case_id"}
      t.references :contact_representative, index: {:name => "index_case_simple_investigations_contact_representative_id"}

      t.string   :contact_representative_relationship_kind
      t.datetime :interview_at
      t.boolean  :can_self_isolate
      t.boolean  :need_assistance_to_self_isolate
      t.datetime :onset_of_symptoms
      t.datetime :infectious_period_start_at
      t.datetime :infectious_period_end_at
      t.datetime :isolation_period_start_at
      t.datetime :isolation_period_end_at

      t.text     :symptoms, array: true, default: []
      t.string   :guidance
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
