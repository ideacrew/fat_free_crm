class AddCaseNumberSequenceToIndexCases < ActiveRecord::Migration[4.2]
  def self.up
    execute <<-SQL
      CREATE SEQUENCE case_number_seq;
      ALTER SEQUENCE case_number_seq OWNED BY fat_free_crm_index_cases.case_number START 1000;
      ALTER TABLE fat_free_crm_index_cases ALTER COLUMN case_number SET DEFAULT nextval('case_number_seq');
    SQL
  end

  def self.down
    execute <<-SQL
      DROP SEQUENCE case_number_seq;
    SQL
  end
end