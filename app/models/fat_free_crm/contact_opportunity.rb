# frozen_string_literal: true

# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
# == Schema Information
#
# Table name: contact_opportunities
#
#  id             :integer         not null, primary key
#  contact_id     :integer
#  opportunity_id :integer
#  role           :string(32)
#  deleted_at     :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

module FatFreeCrm
  class ContactOpportunity < ActiveRecord::Base
    belongs_to :contact
    belongs_to :opportunity
    validates_presence_of :contact_id, :opportunity_id

    # has_paper_trail :class_name => 'Version'

    ActiveSupport.run_load_hooks(:fat_free_crm_contact_opportunity, self)
  end
end


Opportunity
   - Exposed (creates contact_oppertunity)
   - TestedPositive (creates index_case)

Exposures
Investigations

{
	contact: 'dan',
	contact_cases: [
	  {
	  	 case_number: 66232,
         opened_at: Date.today,
      	 closed_at: nil,
      	 artifacts: [{_type: :text},{_type: :sound}],
      	 investigation_kind: :simple,
	     exposure_investigation: {
	     	_type: 'ExposureInvestigation',
	     	exposure_type: :external,
	        projected_return_date: Date.today + 14.days, #(14 days from onset of symptoms)
  		    interview_at: DateTime.now,
	     	exposure_case: {
		        _type: 'ExternalSimpleExposure',
		        # _type: 'SelfAttestedSimpleExposure'

		        source_name:
		        source_relationship:

		        reporting_agency: account_id,
	            reporting_agency_case_id: case_id,

		        started_at:
		        ended_at:
		        exposure_level:
		        duration:
		        symptoms:
		        guidance:
		        user:
	            assigned_to:
            }
	     },
	     clinical_investigations: [
	  		{
	  			_type: 'ClinicalSimpleInvestigation',
	  			interview_at: DateTime.now,
	  		},
	  		{
	  			_type: 'ClinicalSimpleInvestigation',
	  			interview_at: DateTime.now,
	  		}
	    ]
	  }

    ],

	internal_cases: [
	  {
         contact:
	     exposure_case: {
		  	_type: 'ContactSimpleExposure',
		  	_type: 'PlaceSimpleExposure',

	        source_name:
	        source_relationship:

	        reporting_agency: account_id,
            reporting_agency_case_id: case_id,

	        started_at:
	        ended_at:
	        exposure_level:
	        duration:
	        symptoms:
	        guidance:
	        user:
            assigned_to:
            index_case_id:
	     },
	     clinical_investigations: [
	  		{
	  			_type: 'ClinicalSimpleInvestigation',
	  			interview_at: DateTime.now,
	  		},
	  		{
	  			_type: 'ClinicalSimpleInvestigation',
	  			interview_at: DateTime.now,
	  		}
	    ]
	  }
    ], 

	index_cases: [
      {
      	case_number: 55230,
      	opened_at: Date.today,
      	closed_at: nil,
      	artifacts: [{_type: :text},{_type: :sound}],
      	investigation_kind: :simple,
      	index_case_investigation: {
      		_type: 'IndexCaseSimpleInvestigation',
  			onset_of_symptoms: DateTime.now,
	      	projected_return_date: Date.today + 14.days, #(14 days from onset of symptoms)
  		    interview_at: DateTime.now,
  		    lot_number: 543,
        },
  		contact_elicitation_investigation: {
  			_type: 'ContactElicitationInvestigation',
  			window_start_at: DateTime.now,
	      	window_end_at: DateTime.now + 48.hours,
	      	interview_at: DateTime.now,
  			exposure_cases: [
  				{_type: 'ContactSimpleExposure'},
  				{_type: 'ContactSimpleExposure'},
  				{_type: 'PlaceSimpleExposure'}
  			]
  		},
        clinical_investigations: [
      		{
      			_type: 'ClinicalSimpleInvestigation',
      			interview_at: DateTime.now,
      		},
      		{
      			_type: 'ClinicalSimpleInvestigation',
      			interview_at: DateTime.now,
      		}
      	]
      }
	]
}



M&T
  - Account (Head Office)
  - Accounts (2 branches)

  - Facility


  Account has_and_belongs_to_many :facilities 

  User (only for login and authorization)


  Contact (emloyee)
    - Account(branch)


  contact 1
  contact 2(option available to create a case)

  	- two options available 
  	 
  	 - tested_positive
  	    - you create an index case 
  	 
  	 - exposed
  	    - you create a contact opertunity 





  









Contact 
  - Account
  - ContactOpportunities
  - IndexCases

  - Exposures (= external)

IndexCase
	window_start_date
	window_end_date
	- Investigations (will get from Interviews)
		- IndexCaseInvestigation
		- ContactElicitationInvestigation
		    - ContactSimpleExposure
		    - ContactDetailedExposure
		    - PlaceExposures
		- ClinicalSimpleInvestigation
		- ClinicalDetailedInvestigation


Exposure
	- Investigations (will get from Interviews)
	    - InternalExposureInvestigation
		    - ContactSimpleExposure
		    - ContactDetailedExposure
	    - ExternalExposureInvestigation
		    - ContactSimpleExposure
		    - ContactDetailedExposure
	    - ClinicalSimpleInvestigation
	    - ClinicalDetailedInvestigation









  # - Investigations
