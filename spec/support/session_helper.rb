module SessionHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'E-mail', with: user.email
    fill_in 'Senha', with: user.password
    click_button 'Acessar o sistema'
  end
end

RSpec.configure do |config|
  config.include SessionHelper, :type => :feature
end
