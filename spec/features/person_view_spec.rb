require 'rails_helper'

describe 'the person view', type: :feature do

  let(:person) { Person.create(first_name: 'Buzz', last_name: 'Aldrin') }

  before(:each) do
    person.phone_numbers.create(number: '3334445555')
    person.phone_numbers.create(number: '4445556666')
    visit person_path(person)
  end

  it 'shows the phone numbers' do
    person.phone_numbers.each do |phone|
      expect(page).to have_content(phone.number)
    end
  end

  it 'has a link to add a new phone number' do
    expect(page).to have_link('Add phone number', href: new_phone_number_path(person_id: person.id))
  end

  it 'adds a new phone number' do
    page.click_link('Add phone number')
    page.fill_in('Number', with: '7778889999')
    page.click_button('Create Phone number')
    expect(current_path).to eq(person_path(person))
    expect(page).to have_content('7778889999')
  end

  it 'has links to edit phone numbers' do
    person.phone_numbers.each do |phone|
      expect(page).to have_link('edit', href: edit_phone_number_path(phone))
    end
  end

  it 'edits a phone number' do
    phone = person.phone_numbers.first
    old_number = phone.number

    first(:link, 'edit').click
    page.fill_in('Number', with: '555-9999')
    page.click_button('Update Phone number')
    expect(current_path).to eq(person_path(person))
    expect(page).to have_content('555-9999')
    expect(page).to_not have_content(old_number)
  end

  it 'has links to delete phone numbers' do
    person.phone_numbers.each do |phone|
      expect(page).to have_link('Destroy', href: phone_number_path(phone))
    end
  end

  it 'deletes a phone number' do
    phone = person.phone_numbers.first

    first(:link, 'Destroy').click
    # page.click_button('Update Phone number')
    expect(current_path).to eq(person_path(person))
  end


end
