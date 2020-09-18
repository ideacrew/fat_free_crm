class AddResponseReasonToWellnessStatuses < ActiveRecord::Migration[6.0]
  def change
    add_column :fat_free_crm_wellness_statuses, :response_reason, :string
  end
end 