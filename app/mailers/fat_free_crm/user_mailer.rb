# frozen_string_literal: true

# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module FatFreeCrm
  class UserMailer < ActionMailer::Base
    def assigned_entity_notification(entity, assigner)
      @entity_url = url_for(entity)
      @entity_name = entity.name
      @entity_type = entity.class.name.demodulize
      @assigner_name = assigner.name
      mail subject: "Fat Free CRM: You have been assigned #{@entity_name} #{@entity_type}",
           to: entity.assignee.email,
           from: from_address
    end

    def index_case_notification_to_contact(entity)
      @entity_url = url_for(entity)
      @entity_name = entity.contact.full_name

      mail({subject: "COVID-19 Test Positive", to: entity.contact.email, from: from_address})
    end

    def index_case_notification_to_manager(entity)
      url = url_for(entity)
      @signature = create_access_signature(url)
      @facility =  entity.contact.assignments.current.first&.facility
      @account = entity.contact.account
      if @signature.present? && manager_emails.present?
        mail({to: manager_emails, subject: "COVID-19 Test Positive", from: from_address}) do |format|
          format.html {render "index_case_notification_to_manager", locals: {index_case: entity}}
        end
      end
    end

    def exposure_notification_to_manager(entity)
      url = url_for(entity.index_case)
      @signature = create_access_signature(url)
      @facility =  entity.index_case.contact.assignments.current.first&.facility
      @account = entity.index_case.contact.account
      if @signature.present? && manager_emails.present?
        mail({to: manager_emails, subject: "COVID-19 Exposure", from: from_address}) do |format|
          format.html {render "exposure_notification_to_manager"}
        end
      end
    end

    def daily_attestation_remainder(contact)
      mail({to: contact.email, subject: "Daily Attestation Remainder", from: from_address}) do |format|
        format.html {render "daily_attestation_remainder_to_contact", locals: {contact: contact} }
      end
    end

    private

    def secret_key_base
      Rails.application.credentials.secret_key_base || Rails.application.secrets.secret_key_base
    end

    def verifier
      ActiveSupport::MessageVerifier.new(secret_key_base, serializer: JSON, digest: 'SHA256')
    end

    def create_access_signature(url)
      verifier.generate(url)
    end

    def from_address
      Setting.dig(:smtp, :from).presence || "COMPASS Contact Tracing <noreply@fatfreecrm.com>"
    end

    def manager_emails
     #TODO need to update to manager of that contact
      ['harshavardhan.ellanki@ideacrew.com', 'angus.irvine@ideacrew.com', 'trevor.garner@ideacrew.com']
    end
  end
end
