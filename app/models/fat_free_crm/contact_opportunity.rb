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


# Opportunity
#    - Exposed (creates contact_oppertunity)
#    - TestedPositive (creates index_case)

# Exposures
# Investigations
{
  internal_cases: [
    {
      contact: 'dan',
      exposure_case: {
        _type: 'ContactSimpleExposure',
        _type: 'FacilitySimpleExposure',
        _type: 'PlaceSimpleExposure',

        # index_case_id: 123456789,
        # 

        # source_name:
        # source_relationship:

        # reporting_agency: account_id,
        # reporting_agency_case_id: case_id,

        started_at: Date.today,
        ended_at: Date.today + 1.day,
        exposure_level: :medium,
        duration: 2.days,
        symptoms: :unknown,
        guidance: nil,
        user: nil,
        assigned_to: nil,

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




# Contact
#   - Account
#   - ContactOpportunities
#   - IndexCases

#   - Exposures (= external)

# IndexCase
#   window_start_date
#   window_end_date
#   - Investigations (will get from Interviews)
#     - IndexCaseInvestigation
#     - ContactElicitationInvestigation
#         - ContactSimpleExposure
#         - ContactDetailedExposure
#         - PlaceExposures
#     - ClinicalSimpleInvestigation
#     - ClinicalDetailedInvestigation


# Exposure
#   - Investigations (will get from Interviews)
#       - InternalExposureInvestigation
#         - ContactSimpleExposure
#         - ContactDetailedExposure
#       - ExternalExposureInvestigation
#         - ContactSimpleExposure
#         - ContactDetailedExposure
#       - ClinicalSimpleInvestigation
#       - ClinicalDetailedInvestigation


# - Investigations
