class ChangeContactElicitationInvestigation < ActiveRecord::Migration[6.0]
  def change
    add_column :fat_free_crm_investigations_contact_elicitation_investigations, :facility_case_id, :string
    add_column :fat_free_crm_facility_cases, :access, :string
  end
end