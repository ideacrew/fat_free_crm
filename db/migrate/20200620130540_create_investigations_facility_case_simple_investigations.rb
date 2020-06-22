class CreateInvestigationsFacilityCaseSimpleInvestigations < ActiveRecord::Migration[6.0]
  def change
    create_table :investigations_facility_case_simple_investigations do |t|
      t.references :facility_case, index: {:name => "facility_case_simple_investigations_facility_case_id"}
      t.references :contact_representative, index: {:name => "facility_case_simple_investigations_contact_representative_id"}

      # t.boolean  :can_self_isolate
      # t.boolean  :need_assistance_to_self_isolate
      t.datetime :interview_at
      # t.datetime :onset_of_symptoms
      # t.date     :projected_return_date
      # t.text     :symptoms, array: true, default: []
      t.string   :guidance
      t.datetime :deleted_at

      t.timestamps
    end
  end
end