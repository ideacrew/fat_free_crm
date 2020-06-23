class CreateContactIndexCases < ActiveRecord::Migration[6.0]

  def change
    create_table :fat_free_crm_contact_index_cases do |t|
      t.references :contact
      t.references :index_case
      
      t.bigint     :notifying_account_id
      t.bigint     :notifying_contact_id
      t.datetime   :notified_at
      t.datetime   :deleted_at

      t.timestamps
    end
  end
end