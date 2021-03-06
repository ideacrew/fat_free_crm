# frozen_string_literal: true

# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

module FatFreeCrm
  describe "/fat_free_crm/admin/users/index" do
    before do
      login_admin
    end

    it "renders a list of users" do
      assign(:users, [build_stubbed(:user)].paginate)

      render
      expect(view).to render_template(partial: "_user")
      expect(view).to render_template(partial: "fat_free_crm/shared/_paginate")
    end
  end
end
