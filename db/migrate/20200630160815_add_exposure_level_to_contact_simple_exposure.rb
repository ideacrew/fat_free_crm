class AddExposureLevelToContactSimpleExposure < ActiveRecord::Migration[6.0]
  def change
    add_column :fat_free_crm_exposures_contact_simple_exposures, :exposure_level, :string
  end
end