# frozen_string_literal: true

# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'

module FatFreeCrm
  describe "/fat_free_crm/leads/_sidebar_show" do

    before do
      view.extend FatFreeCrm::AddressesHelper
      login
      assign(:users, [current_user])
      assign(:comment, Comment.new)
      assign(:lead, build_stubbed(:lead,
                                  blog: 'http://www.blogger.com/home',
                                  linkedin: 'www.linkedin.com',
                                  twitter: 'twitter.com/account',
                                  facebook: ''))
    end

    it "should render working web presence links whether a protocol is provided or not" do
      render
      expect(rendered).to have_tag("a[href='http://www.blogger.com/home']")
      expect(rendered).to have_tag("a[href='http://www.linkedin.com']")
      expect(rendered).to have_tag("a[href='http://twitter.com/account']")
      expect(rendered).not_to have_tag("a[href='http://www.facebook/profile']")
    end
  end
end