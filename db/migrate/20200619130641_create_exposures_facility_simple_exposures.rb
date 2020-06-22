class CreateExposuresFacilitySimpleExposures < ActiveRecord::Migration[6.0]
  def change
    create_table :exposures_facility_simple_exposures do |t|
      t.references :facility, index: {:name => "facility_simple_exposures_facility_id"}

      t.integer    :priority_level
      t.string     :congregate_setting

      t.datetime   :exposure_started_at
      t.datetime   :exposure_ended_at
      t.integer    :duration_in_minutes
      
      t.boolean    :used_mask
      t.datetime   :deleted_at

      t.timestamps
    end
  end
end
