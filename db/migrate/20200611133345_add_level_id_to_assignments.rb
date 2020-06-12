class AddLevelIdToAssignments < ActiveRecord::Migration[6.0]
  def change
    add_reference :fat_free_crm_assignments, :level, foreign_key: true
  end
end