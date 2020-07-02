class AddCaseNumberSequenceToCases < ActiveRecord::Migration[4.2]
  def self.up
    execute <<-SQL
      CREATE SEQUENCE case_number_seq INCREMENT 1 START 1001;
      ALTER TABLE fat_free_crm_index_cases ALTER COLUMN case_number SET DEFAULT nextval('case_number_seq');
      ALTER TABLE fat_free_crm_exposure_cases ALTER COLUMN case_number SET DEFAULT nextval('case_number_seq');
      ALTER TABLE fat_free_crm_facility_cases ALTER COLUMN case_number SET DEFAULT nextval('case_number_seq');
    SQL
  end

  def self.down
    execute <<-SQL
      ALTER TABLE fat_free_crm_index_cases ALTER COLUMN case_number SET NOT NULL;
      ALTER TABLE fat_free_crm_exposure_cases ALTER COLUMN case_number SET NOT NULL;
      ALTER TABLE fat_free_crm_facility_cases ALTER COLUMN case_number SET NOT NULL;
      DROP SEQUENCE case_number_seq;
    SQL
  end
end