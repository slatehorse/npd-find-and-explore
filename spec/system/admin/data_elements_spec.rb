# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Data Items', type: :system do
  let(:password) { 'paSSw0rd!' }
  let(:admin_user) { AdminUser.create!(email: 'admin@test.com', password: password) }

  before do
    DataElement.destroy_all
    Concept.destroy_all
    Category.destroy_all

    admin_user
    create(:concept, :with_data_elements)

    visit '/admin'
    fill_in('admin_user_email', with: admin_user.email)
    fill_in('admin_user_password', with: password)
    click_on('Log in')
  end

  it 'Will display the index' do
    visit '/admin/data_elements'

    expect(page).to have_text('Dataset')
    expect(page).to have_text('Unique alias')
    expect(page).to have_text('Concept')
    expect(page).to have_text('Datasets')
  end

  it 'Will display a data item' do
    data_element = DataElement.first
    visit "/admin/data_elements/#{data_element.id}"

    expect(page).to have_text(data_element.id)
    expect(page).to have_text(data_element.unique_alias)
  end
end
