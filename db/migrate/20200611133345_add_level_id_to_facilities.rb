class AddLevelIdToFacilities < ActiveRecord::Migration[6.0]
  def change
    add_reference :fat_free_crm_facilities, :level, foreign_key: true
  end
end