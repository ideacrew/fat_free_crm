class ChangeAttributesOnIndexCases < ActiveRecord::Migration[6.0]
  def change
  	remove_column :fat_free_crm_index_cases, :window_start_date
  	remove_column :fat_free_crm_index_cases, :window_end_date
  	remove_column :fat_free_crm_index_cases, :opportunity_id
  	remove_column :fat_free_crm_index_cases, :contact_id

    add_column :fat_free_crm_index_cases, :investigation_kind, :string

  end
end