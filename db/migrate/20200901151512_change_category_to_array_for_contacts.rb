class ChangeCategoryToArrayForContacts < ActiveRecord::Migration[6.0]
  def change
    change_column :fat_free_crm_contacts, :category, :string, array: true, default: [], using: "(string_to_array(category, ','))"
  end
end