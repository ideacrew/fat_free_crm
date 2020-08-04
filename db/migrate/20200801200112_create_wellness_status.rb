class CreateWellnessStatus < ActiveRecord::Migration[6.0]

  def change
    create_table :fat_free_crm_wellness_statuses do |t|
      t.references :contact

      t.string :key
      t.string :status
      t.string :category
      t.datetime :begin_on
      t.datetime :expire_on

      t.timestamps
    end
  end
end