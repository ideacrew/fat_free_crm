module FatFreeCrm

  class WellnessStatus < ActiveRecord::Base

    belongs_to :contact, class_name: "::FatFreeCrm::Contact"
    has_many   :attestations, dependent: :destroy
  
    has_paper_trail versions: {class_name: "FatFreeCrm::Version"}

    accepts_nested_attributes_for :attestations,  allow_destroy: true
    enum response_states: {no_response: 'no_response', response_submitted: 'response_submitted', response_not_required: 'response_not_required', absent_index_case_status: 'absent_index_case_status', absent_exposure_case_status: 'absent_exposure_case_status', absent_pto_status: 'absent_pto_status', absent_remote_status: 'absent_remote_status', absent_not_scheduled: 'absent_not_scheduled', absent_other: 'absent_other'}
    default_scope { order(created_at: :asc) }

    scope :current, -> { where(attested_at: Date.today.all_day) }
  end
end