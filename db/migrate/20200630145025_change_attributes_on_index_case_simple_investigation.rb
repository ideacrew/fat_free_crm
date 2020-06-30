class ChangeAttributesOnIndexCaseSimpleInvestigation < ActiveRecord::Migration[6.0]
  def change
  	remove_column :fat_free_crm_investigations_index_case_simple_investigations, :symptoms

    add_column :fat_free_crm_investigations_index_case_simple_investigations, :work_related, :string
    add_column :fat_free_crm_investigations_index_case_simple_investigations, :how_virus_contracted, :text
  end
end