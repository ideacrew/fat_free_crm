class CreateContactIndexCases < ActiveRecord::Migration[6.0]

  def change
    
    create_table :fat_free_crm_contact_index_cases do |t|

      t.references :contact
      t.references :index_case

      t.string     :case_id
      t.integer    :investigation_priority
      
      t.datetime   :window_opens_at
      t.datetime   :window_closes_at

      t.datetime   :deleted_at

      t.timestamps
    end
  end
end