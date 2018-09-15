require "application_system_test_case"

class ContactsTest < ApplicationSystemTestCase
  setup do
    @contact = contacts(:one)
  end

  test "visiting the index" do
    visit contacts_url
    assert_selector "h1", text: "Contacts"
  end

  test "creating a Contact" do
    visit contacts_url
    click_on "New Contact"

    fill_in "Client Id Integer", with: @contact.client_id_integer
    fill_in "Comments", with: @contact.comments
    fill_in "Email Address", with: @contact.email_address
    fill_in "First Name", with: @contact.first_name
    fill_in "Last Name ", with: @contact.last_name_
    fill_in "Position", with: @contact.position
    fill_in "Priority", with: @contact.priority
    fill_in "Telephone Number", with: @contact.telephone_number
    click_on "Create Contact"

    assert_text "Contact was successfully created"
    click_on "Back"
  end

  test "updating a Contact" do
    visit contacts_url
    click_on "Edit", match: :first

    fill_in "Client Id Integer", with: @contact.client_id_integer
    fill_in "Comments", with: @contact.comments
    fill_in "Email Address", with: @contact.email_address
    fill_in "First Name", with: @contact.first_name
    fill_in "Last Name ", with: @contact.last_name_
    fill_in "Position", with: @contact.position
    fill_in "Priority", with: @contact.priority
    fill_in "Telephone Number", with: @contact.telephone_number
    click_on "Update Contact"

    assert_text "Contact was successfully updated"
    click_on "Back"
  end

  test "destroying a Contact" do
    visit contacts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Contact was successfully destroyed"
  end
end
