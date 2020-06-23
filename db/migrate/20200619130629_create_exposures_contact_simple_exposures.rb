class CreateExposuresContactSimpleExposures < ActiveRecord::Migration[6.0]
  def change
    create_table :fat_free_crm_exposures_contact_simple_exposures do |t|
  	  t.references :contact_exposure_case, index: {:name => "contact_simple_exposures_contact_exposure_case_id"}
      
      t.integer    :contact_exposure_investigation_priority
      t.string     :facility_congregate_setting
      t.datetime   :exposure_started_at
      t.datetime   :exposure_ended_at
      t.integer    :duration_in_minutes
      t.string     :exposure_level
      t.string     :guidance
      t.boolean    :used_mask
      t.datetime   :deleted_at

      t.timestamps
    end
  end
end
