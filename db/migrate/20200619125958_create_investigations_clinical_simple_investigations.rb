class CreateInvestigationsClinicalSimpleInvestigations < ActiveRecord::Migration[6.0]
  def change
    create_table :investigations_clinical_simple_investigations do |t|
  
      t.references :index_case
      t.references :exposure_case
      t.references :health_care_provider
      t.references :contact_representative

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
