class CreateContactExposureCases < ActiveRecord::Migration[6.0]
  def change
    create_table :fat_free_crm_contact_exposure_cases do |t|
      t.references :contact
      t.references :exposure_case
      t.references :contact_elicitation_investigation, index: {:name => "contact_exposure_cases_contact_elicitation_investigation_id"}
      t.references :facility
      t.references :facility_case
      t.datetime   :deleted_at

      t.timestamps
    end
  end
end