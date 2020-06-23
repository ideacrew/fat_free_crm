class CreateFacilityCases < ActiveRecord::Migration[6.0]
  def change
    create_table :fat_free_crm_facility_cases do |t|
      t.references :user
      t.references :facility

      t.integer    :assigned_to
      t.integer    :case_number
      t.datetime   :opened_at
      t.datetime   :closed_at
      t.string     :investigation_kind
      t.datetime   :deleted_at
      
      t.timestamps
    end
  end
end


