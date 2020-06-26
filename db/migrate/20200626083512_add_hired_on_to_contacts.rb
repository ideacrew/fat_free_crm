class AddHiredOnToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column  :fat_free_crm_contacts, :hired_on, :date
  end
end