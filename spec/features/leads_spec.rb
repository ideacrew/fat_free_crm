# frozen_string_literal: true

# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require File.expand_path('acceptance_helper.rb', __dir__)

feature 'Leads', '
  In order to increase sales
  As a user
  I want to manage leads
' do
  before(:each) do
    self.class.include FatFreeCrm::Engine.routes.url_helpers
    do_login_if_not_already(first_name: 'Bill', last_name: 'Murray')
  end

  scenario 'should view a list of leads' do
    4.times { |i| create(:lead, first_name: "L", last_name: "Ead #{i}") }
    visit leads_page
    expect(leads_element).to have_content('L Ead 0')
    expect(leads_element).to have_content('L Ead 1')
    expect(leads_element).to have_content('L Ead 2')
    expect(leads_element).to have_content('L Ead 3')
    expect(page).to have_content('Create Lead')
  end

  scenario 'should create a new lead', js: true do
    with_versioning do
      visit leads_page
      click_link 'Create Lead'
      expect(page).to have_selector('#lead_first_name', visible: true)
      fill_in 'lead_first_name', with: 'Mr'
      fill_in 'lead_last_name', with: 'Lead'
      fill_in 'lead_email', with: 'mr_lead@example.com'
      fill_in 'lead_phone', with: '+44 1234 567890'
      expand_status
      find("select", id: "lead_assigned_to", wait: 10).select('Myself')
      #select 'Myself', from: 'lead_assigned_to'
      select 'Contacted', from: 'lead_status'
      select 'Campaign', from: 'lead_source'
      select 'Contacted', from: 'lead_status'
      expand_comment
      find("textarea", id: "comment_body", wait: 10).set("This is an important lead.")
      # fill_in 'comment_body', with: 'This is an important lead.'
      click_button 'Create Lead'

      sleep 1

      expect(leads_element).to have_content('Mr Lead')

      leads_element.click_link('Mr Lead')

      sleep 1

      expect(summary_element).to have_content('Contacted')
      expect(summary_element).to have_content('mr_lead@example.com')
      expect(summary_element).to have_content('+44 1234 567890')
      expect(main_element).to have_content('This is an important lead.')

      click_link "Dashboard"
      expect(activities_element).to have_content("Bill Murray created lead Mr Lead")
      expect(activities_element).to have_content("Bill Murray created comment on Mr Lead")
    end
  end

  scenario "remembers the comment field when the creation was unsuccessful", js: true do
    visit leads_page
    click_link 'Create Lead'

    expand_comment
    fill_in 'comment_body', with: 'This is an important lead.'
    click_button 'Create Lead'

    expect(page).to have_field('comment_body', with: 'This is an important lead.')
  end

  scenario 'should view and edit a lead', js: true do
    create(:lead, first_name: "Mr", last_name: "Lead", email: "mr_lead@example.com")
    with_versioning do
      visit leads_page
      click_link 'Mr Lead'
      expect(page).to have_content('Mr Lead')
      click_link('Edit')
      fill_in 'lead_first_name', with: 'Mrs'
      fill_in 'lead_phone', with: '+44 0987 654321'

      expand_status
      find("select", id: "lead_status").select("Rejected")
      #select 'Rejected', from: 'lead_status'
      click_button 'Save Lead'
      expect(summary_element).to have_content('Mrs Lead')

      click_link "Dashboard"
      expect(activities_element).to have_content("Bill Murray updated lead Mrs Lead")
    end
  end

  scenario 'should delete a lead', js: true do
    create(:lead, first_name: "Mr", last_name: "Lead", email: "mr_lead@example.com")
    visit leads_page
    click_link 'Mr Lead'
    click_link 'Delete?'
    expect(page).to have_content('Are you sure you want to delete this lead?')
    click_link 'Yes'
    expect(page).to have_content('Mr Lead has been deleted.')
    expect(page).not_to have_content('Mr Lead')
    expect(page).not_to have_content('mr_lead@example.com')
  end

  scenario 'should search for a lead', js: true do
    2.times { |i| create(:lead, first_name: "Lead", last_name: "\##{i}", email: "lead#{i}@example.com") }
    visit leads_page
    expect(leads_element).to have_content('Lead #0')
    expect(leads_element).to have_content('Lead #1')
    fill_in 'query', with: 'Lead #0'
    expect(leads_element).to have_content('Lead #0')
    expect(leads_element).not_to have_content('Lead #1')
    fill_in 'query', with: 'Lead'
    expect(leads_element).to have_content('Lead #0')
    expect(leads_element).to have_content('Lead #1')
    fill_in 'query', with: 'Non-existant lead'
    expect(leads_element).not_to have_content('Lead #0')
    expect(leads_element).not_to have_content('Lead #1')
  end

  def main_element
    find('#main', wait: 15)
  end

  def summary_element
    find('#summary', wait: 15)
  end

  def leads_element
    find('#leads', wait: 15)
  end

  def activities_element
    find('#activities', wait: 15)
  end

  def expand_status
    summary_element = find("summary", text: 'Status')
    summary_element.execute_script("arguments[0].scrollIntoView();", summary_element.native)

    opened_element = all("details.idc_panel[open] > summary", text: "Summary", wait: 2)
    if opened_element.empty?
      summary_element.click
      sleep 2
    end
  end

  def expand_comment
    summary_element = find("summary", text: 'Comment')
    summary_element.execute_script("arguments[0].scrollIntoView();", summary_element.native)

    opened_element = all("details.idc_panel[open] > summary", text: "Comment", wait: 2)
    if opened_element.empty?
      summary_element.click
      sleep 2
    end
  end
end
