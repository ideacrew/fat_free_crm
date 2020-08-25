class AddExtraAttributesToAccountts < ActiveRecord::Migration[6.0]
  def change
    add_column :fat_free_crm_accounts, :hbx_id, :string
    add_column :fat_free_crm_accounts, :fein, :string
  end
end