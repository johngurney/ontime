require "application_system_test_case"

class UpdateRemindersTest < ApplicationSystemTestCase
  setup do
    @update_reminder = update_reminders(:one)
  end

  test "visiting the index" do
    visit update_reminders_url
    assert_selector "h1", text: "Update Reminders"
  end

  test "creating a Update reminder" do
    visit update_reminders_url
    click_on "New Update Reminder"

    fill_in "Day Time", with: @update_reminder.day_time
    fill_in "Offset", with: @update_reminder.offset
    fill_in "Proportion", with: @update_reminder.proportion
    fill_in "Start End", with: @update_reminder.start_end
    fill_in "Type", with: @update_reminder.type
    click_on "Create Update reminder"

    assert_text "Update reminder was successfully created"
    click_on "Back"
  end

  test "updating a Update reminder" do
    visit update_reminders_url
    click_on "Edit", match: :first

    fill_in "Day Time", with: @update_reminder.day_time
    fill_in "Offset", with: @update_reminder.offset
    fill_in "Proportion", with: @update_reminder.proportion
    fill_in "Start End", with: @update_reminder.start_end
    fill_in "Type", with: @update_reminder.type
    click_on "Update Update reminder"

    assert_text "Update reminder was successfully updated"
    click_on "Back"
  end

  test "destroying a Update reminder" do
    visit update_reminders_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Update reminder was successfully destroyed"
  end
end
