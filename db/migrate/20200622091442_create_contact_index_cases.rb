class CreateContactIndexCases < ActiveRecord::Migration[6.0]

  def change
    create_table :fat_free_crm_contact_index_cases do |t|
      t.references :contact
      t.references :index_case
      t.references :notifying_contact
      
      t.string     :notifying_contact_relationship_kind
      t.datetime   :notified_at
      t.datetime   :deleted_at

      t.timestamps
    end
  end
end