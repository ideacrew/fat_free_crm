class CreateDeclarations < ActiveRecord::Migration[6.0]

  def change
    create_table :fat_free_crm_declarations do |t|
      t.references :attestation

      t.string :key
      t.text :item
      t.text :answer
      t.string :title
      t.string :description
      t.string :kind

      t.timestamps
    end
  end
end
