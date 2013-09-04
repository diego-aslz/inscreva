module SessionHelper
  def sign_in(user, password=nil)
    visit new_user_session_path
    fill_in User.human_attribute_name(:email), with: (user.is_a?(User) ? user.email : user)
    fill_in User.human_attribute_name(:password), with: (password || (user.is_a?(User) ? user.password : ''))
    click_button I18n.t(:'devise.buttons.sign_in')
  end
end

RSpec.configure do |config|
  config.include SessionHelper, :type => :feature
end
