class CreateContactExposureCases < ActiveRecord::Migration[6.0]

  def change
    
    create_table :contact_exposure_cases do |t|

      t.references :contact
      t.references :exposure_case
      t.references :contact_elicitation_investigation, index: {:name => "contact_exposure_cases_contact_elicitation_investigation_id"}
      t.references :facility
      t.references :facility_case

      # t.string :index_case_id
      # t.string :reporting_agency_id
      t.string :case_id
      t.integer :investigation_priority
      t.datetime :window_opens_at
      t.datetime :window_closes_at
      # t.string :exposure_detail_id
      # t.text :visited_locations, array: true, default: []
      t.datetime :deleted_at

      t.timestamps
    end
  end
end