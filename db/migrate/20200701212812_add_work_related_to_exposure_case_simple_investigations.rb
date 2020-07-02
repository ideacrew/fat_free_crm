class AddWorkRelatedToExposureCaseSimpleInvestigations < ActiveRecord::Migration[6.0]
  def change
    add_column :fat_free_crm_investigations_exposure_case_simple_investigations, :work_related, :string
  end
end