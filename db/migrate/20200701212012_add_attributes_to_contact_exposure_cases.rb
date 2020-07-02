class AddAttributesToContactExposureCases < ActiveRecord::Migration[6.0]

  def change
    add_reference :fat_free_crm_contact_exposure_cases, :notifying_contact, index: {:name => "contact_exposure_case_notifying_contact_id"}
    add_column :fat_free_crm_contact_exposure_cases, :notifying_contact_relationship_kind, :string
    add_column :fat_free_crm_contact_exposure_cases, :notified_at, :datetime

  end
end