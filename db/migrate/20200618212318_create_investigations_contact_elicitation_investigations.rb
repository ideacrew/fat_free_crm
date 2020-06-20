class CreateInvestigationsContactElicitationInvestigations < ActiveRecord::Migration[6.0]
  def change
    create_table :investigations_contact_elicitation_investigations do |t|
      t.references :index_case
      t.references :contact_representative

      t.datetime   :interview_at
      t.datetime   :deleted_at

      t.timestamps
    end
  end
end
