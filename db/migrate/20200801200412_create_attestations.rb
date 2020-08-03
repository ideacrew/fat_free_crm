class CreateAttestations < ActiveRecord::Migration[6.0]

  def change
    create_table :fat_free_crm_attestations do |t|
      t.references :wellness_status

      t.string :key
      t.string :title
      t.string :description
      t.boolean :is_attested
      t.datetime :attested_at

      t.timestamps
    end
  end
end
