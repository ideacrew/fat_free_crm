class AddAttestedAtToWellnessStatuses < ActiveRecord::Migration[6.0]
  def change
    add_column :fat_free_crm_wellness_statuses, :attested_at, :datetime
  end
end