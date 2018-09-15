require "application_system_test_case"

class ReminderSchedulesTest < ApplicationSystemTestCase
  setup do
    @reminder_schedule = reminder_schedules(:one)
  end

  test "visiting the index" do
    visit reminder_schedules_url
    assert_selector "h1", text: "Reminder Schedules"
  end

  test "creating a Reminder schedule" do
    visit reminder_schedules_url
    click_on "New Reminder Schedule"

    fill_in "Name", with: @reminder_schedule.name
    click_on "Create Reminder schedule"

    assert_text "Reminder schedule was successfully created"
    click_on "Back"
  end

  test "updating a Reminder schedule" do
    visit reminder_schedules_url
    click_on "Edit", match: :first

    fill_in "Name", with: @reminder_schedule.name
    click_on "Update Reminder schedule"

    assert_text "Reminder schedule was successfully updated"
    click_on "Back"
  end

  test "destroying a Reminder schedule" do
    visit reminder_schedules_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Reminder schedule was successfully destroyed"
  end
end
