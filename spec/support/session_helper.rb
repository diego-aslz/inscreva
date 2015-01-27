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

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!
end
