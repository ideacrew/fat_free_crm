class CreateInvestigationsClinicalSimpleInvestigations < ActiveRecord::Migration[6.0]
  def change
    create_table :investigations_clinical_simple_investigations do |t|
  
      t.references :index_case, index: {:name => "clinical_simple_investigation_index_case_id"}
      t.references :exposure_case, index: {:name => "clinical_simple_investigation_exposure_case_id"}
      t.references :health_care_provider, index: {:name => "clinical_simple_investigation_health_care_provider_id"}
      t.references :contact_representative, index: {:name => "clinical_simple_investigation_contact_representative_id"}

      t.datetime   :interview_at
      t.boolean 	 :hcp_consult_event
      t.boolean 	 :hospitalized_event
      t.boolean 	 :emergency_room_event
      t.boolean 	 :death_event
      t.boolean    :none_of_the_above
      t.date    	 :event_on
      t.datetime   :deleted_at

      t.timestamps
    end
  end
end
