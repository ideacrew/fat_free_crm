class CreateExposuresContactSimpleExposures < ActiveRecord::Migration[6.0]
  def change
    create_table :exposures_contact_simple_exposures do |t|
  	
  	  t.references :contact_exposure_case
  	  t.references :facility
      
      t.integer    :priority_level
      t.string     :congregate_setting

      t.datetime   :exposure_started_at
      t.datetime   :exposure_ended_at
      t.integer    :duration_in_minutes
      t.string     :exposure_level
      t.text       :symptoms, array: true, default: []
      
      t.string     :guidance
      t.boolean    :used_mask
      t.datetime   :deleted_at

      t.timestamps
    end
  end
end
