class CreateInvestigationsContactElicitationInvestigations < ActiveRecord::Migration[6.0]
  def change
    create_table :fat_free_crm_investigations_contact_elicitation_investigations do |t|
      t.references :index_case, index: {:name => "contact_elicitation_investigation_index_case_id"}
      t.references :contact_representative, index: {:name => "contact_elicitation_investigation_contact_representative_id"}

      t.datetime   :interview_at
      t.datetime   :deleted_at

      t.timestamps
    end

  end
end
