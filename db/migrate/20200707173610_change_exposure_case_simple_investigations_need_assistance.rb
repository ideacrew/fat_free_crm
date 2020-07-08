class ChangeExposureCaseSimpleInvestigationsNeedAssistance < ActiveRecord::Migration[6.0]
  def change
    remove_column :fat_free_crm_investigations_exposure_case_simple_investigations, :need_assitance_to_self_quarantine
    add_column    :fat_free_crm_investigations_exposure_case_simple_investigations, :need_assistance_to_self_quarantine, :boolean
  end
end