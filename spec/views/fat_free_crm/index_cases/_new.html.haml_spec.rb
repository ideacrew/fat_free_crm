require 'spec_helper'

module FatFreeCrm
  describe "/fat_free_crm/index_cases/_new" do
    let(:contact) { create(:contact) }
    let(:index_case) { create(:index_case, contact: contact) }

    before do
      login
      assign(:index_case, index_case)
    end

    it "should render [create index_case] form" do
      render
      # Form
      expect(rendered).to include('<form class="edit_index_case"')
      # Top Section
      expect(rendered).to include("<label>Phone:</label>")
      expect(rendered).to include("<label>Email:</label>")
      expect(rendered).to include("<label>Window Start Date:</label>")
      expect(rendered).to include("<label>Window End Date:</label>")
      expect(rendered).to include("<label>Projected Return Date:</label>")
      expect(rendered).to include("<summary>Permissions</summary>")
      expect(rendered).to include('<label for="index_case_group_ids">Groups:</label>')
    end
  end
end
