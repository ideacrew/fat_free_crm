class AddResponseStateToWellnessStatuses < ActiveRecord::Migration[6.0]
  def change
    add_column :fat_free_crm_wellness_statuses, :response_state, :string, default: "no_response"
  end
end