require 'spec_helper'

module FatFreeCrm
  describe "/fat_free_crm/index_cases/index" do
    let(:contact) { create(:contact) }
    let(:index_case) { create(:index_case, contact: contact) }

    before do
      login
    end

    it "should render index cases index" do
      assign(:index_cases, [build_stubbed(:index_case, id: 10)].paginate)
      render
      expect(rendered).to include("<h1 id='create_index_case_title'>Index Cases</h1>")
      expect(rendered).to include("<div id='paginate'>")
      expect(rendered).to include("<label>Search index cases</label>")
      expect(rendered).to include("<div class='per_page_options'>")
    end
  end
end
