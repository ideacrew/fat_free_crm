require 'spec_helper'

module FatFreeCrm
  describe "/fat_free_crm/index_cases/_edit" do
    let(:contact) { create(:contact) }
    let(:index_case) { create(:index_case, contact: contact) }
    let!(:investigation) { create(:investigation, index_case: index_case)}
    let(:create_registry) { Object.const_set('CovidMostRegistry', {index_case_symptoms: index_case_symptoms, contact_relationship: contact_relationship}) }
    let(:index_case_symptoms) {
      double(item: {
          "fever" => "Fever",
          "cough" => "Cough",
          "shortness_of_breath" => "Shortness of Breath",
          "diarrhea" => "Diarrhea",
          "headache" => "Headache"
      })
    }

    let(:contact_relationship) {
      double(item: {
          "self" => "Self",
          "spouse" => "Spouse",
          "child" => "Child",
          "friend" => "Friend",
          "other" => "Other"
      })
    }

    before do
      login
      create_registry
      index_case.build_index_case_investigation
      assign(:index_case, index_case)
    end

    it "should render [edit index_case] form" do
      render
      # Form
      expect(rendered).to include('<form class="edit_index_case"')
      # Top Section
      # Remote only appears on edit
      expect(rendered).to include("<div class='remote'>")
      expect(rendered).to include("<label>Phone:</label>")
      expect(rendered).to include("<label>Email:</label>")
      expect(rendered).to include("<label>Symptom Onset At:</label>")
      expect(rendered).to include("<label>Isolation Period Start At:</label>")
      expect(rendered).to include("<label>Projected Return Date:</label>")
      expect(rendered).to include("<summary>Permissions</summary>")
      expect(rendered).to include('<label for="index_case_group_ids">Groups:</label>')
      # Index Case Invesetigations partial
      expect(rendered).to include('clinical_investigations')
      # Investigation partial
      expect(rendered).to include("<div id='new_investigation'>")
    end
  end
end