# frozen_string_literal: true

# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

module FatFreeCrm
  describe "/fat_free_crm/campaigns/index" do

    before do
      view.lookup_context.prefixes << 'entities'
      assign :per_page, Campaign.per_page
      assign :sort_by,  Campaign.sort_by
      assign :ransack_search, Campaign.ransack
      login
    end

    it "should render list of accounts if list of campaigns is not empty" do
      assign(:campaigns, [build_stubbed(:campaign)].paginate)

      render
      expect(view).to render_template(partial: "_campaign")
      expect(view).to render_template(partial: "fat_free_crm/shared/_paginate_with_per_page")
    end

    it "should render a message if there're no campaigns" do
      assign(:campaigns, [].paginate)

      render
      expect(view).not_to render_template(partial: "_campaigns")
      expect(view).to render_template(partial: "fat_free_crm/shared/_empty")
      expect(view).to render_template(partial: "fat_free_crm/shared/_paginate_with_per_page")
    end
  end
end
