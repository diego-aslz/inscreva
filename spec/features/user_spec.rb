require 'spec_helper'
require "cancan/matchers"

describe "User" do
  let(:admin) { create(:admin, password: '123456789',
    password_confirmation: '123456789') }
  let(:created_user) { User.find_by_email('diego@mail.com') }

  before(:each) do
    sign_in admin, '123456789'

    visit new_user_path
    fill_in 'Nome', with: 'Diego'
    fill_in 'E-mail', with: 'diego@mail.com'
    fill_in 'Senha', with: '123456789'
    fill_in 'Redigite', with: '123456789'
  end

  it "creates user" do
    uncheck 'Administrador'
    uncheck 'Pode criar'

    expect{ click_button 'Criar' }.to change(User, :count).by(1)

    expect(Ability.new(created_user)).not_to be_able_to(:create, Event)
    expect(created_user).not_to be_admin
  end

  it "creates admin" do
    check 'Administrador'

    expect{ click_button 'Criar' }.to change(User, :count).by(1)

    expect(created_user).to be_admin
  end

  it "can be allowed to create Event" do
    uncheck 'Administrador'
    check 'Pode criar'

    expect{ click_button 'Criar' }.to change(User, :count).by(1)

    expect(Ability.new(created_user)).to be_able_to(:create, Event)
  end
end
