# frozen_string_literal: true

# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

module FatFreeCrm
  describe "/fat_free_crm/contacts/show" do

    before do
      view.controller.extend ::FatFreeCrm::Engine.routes.url_helpers
      login
      @contact = create(:contact, id: 42,
                                  opportunities: [create(:opportunity)])
      assign(:contact, @contact)
      assign(:users, [current_user])
      assign(:comment, Comment.new)
      assign(:timeline, [create(:comment, commentable: @contact)])

      # controller#controller_name and controller#action_name are not set in view specs
      allow(view).to receive(:template_for_current_view).and_return(nil)
    end

    it "should render contact landing page" do
      render
      expect(view).to render_template(partial: "fat_free_crm/comments/_new")
      expect(view).to render_template(partial: "fat_free_crm/shared/_timeline")
      expect(view).to render_template(partial: "fat_free_crm/shared/_tasks")
      expect(view).to render_template(partial: "fat_free_crm/opportunities/_opportunity")

      expect(rendered).to have_tag("div[id=edit_contact]")
    end
  end
end
