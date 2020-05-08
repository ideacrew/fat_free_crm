# frozen_string_literal: true

# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

module FatFreeCrm
  describe "/fat_free_crm/leads/index" do

    before do
      login
    end

    it "should render [lead] template with @leads collection if there are leads" do
      assign(:leads, [build_stubbed(:lead, id: 42)].paginate(page: 1, per_page: 20))

      render template: 'fat_free_crm/leads/index', formats: [:js]

      expect(rendered).to include("$('#leads').html('<li class=\\'fat_free_crm_lead highlight\\' id=\\'fat_free_crm_lead_42\\'")
      expect(rendered).to include("#paginate")
    end

    it "should render [empty] template if @leads collection if there are no leads" do
      assign(:leads, [].paginate(page: 1, per_page: 20))

      render template: 'fat_free_crm/leads/index', formats: [:js]

      expect(rendered).to include("$('#leads').html('<div id=\\'empty\\'>")
      expect(rendered).to include("#paginate")
    end
  end
end