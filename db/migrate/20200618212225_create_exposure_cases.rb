class CreateExposureCases < ActiveRecord::Migration[6.0]
  def change
    create_table :fat_free_crm_exposure_cases do |t|
      t.references :user
      t.references :contact

      t.integer    :assigned_to
      t.integer    :case_number
      t.datetime   :opened_at
      t.datetime   :closed_at
      t.string     :investigation_kind
      t.date       :projected_return_date
      t.datetime   :deleted_at

      t.timestamps
    end
  end
end







