class CreateInvestigationsExposureCaseSimpleInvestigations < ActiveRecord::Migration[6.0]
  def change
    create_table :fat_free_crm_investigations_exposure_case_simple_investigations do |t|
      t.references :exposure_case, index: {:name => "exposure_case_simple_investigations_exposure_case_id"}
      t.references :contact_representative, index: {:name => "exposure_case_simple_investigations_contact_representative_id"}

      t.datetime   :interview_at
      t.boolean    :can_self_quarantine
      t.boolean    :need_assitance_to_self_quarantine
      t.string     :guidance
      t.datetime   :deleted_at

      t.timestamps
    end
  end
end


