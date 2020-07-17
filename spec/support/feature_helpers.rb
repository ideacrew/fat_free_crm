# frozen_string_literal: true

# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------

module FeatureHelpers
  # Put helper methods you need to be available in all acceptance specs here.

  def do_login(options = {})
    @user = create(:user, options)
    @user.confirm
    @user.update_attribute(:suspended_at, nil)
    login_as(@user)
  end

  def login_as_user(user)
    user.confirm
    user.update_attribute(:suspended_at, nil)
    visit '/crm/users/sign_in'
    fill_in "user[email]", with: user.username
    fill_in "user[password]", with: user.password
    click_button "Login"
  end

  # if we're already logged in, don't bother doing it again
  def do_login_if_not_already(options = {})
    do_login(options) unless @user.present?
  end

  def create_registry
    google_api = double(setting:  double(item: ENV['GOOGLE_API_KEY']))
    @create_registry ||= Object.const_set('CovidMostRegistry', {google_api: google_api} )
  end
end
