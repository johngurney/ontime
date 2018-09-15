require 'test_helper'

class UpdateRemindersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @update_reminder = update_reminders(:one)
  end

  test "should get index" do
    get update_reminders_url
    assert_response :success
  end

  test "should get new" do
    get new_update_reminder_url
    assert_response :success
  end

  test "should create update_reminder" do
    assert_difference('UpdateReminder.count') do
      post update_reminders_url, params: { update_reminder: { day_time: @update_reminder.day_time, offset: @update_reminder.offset, proportion: @update_reminder.proportion, start_end: @update_reminder.start_end, type: @update_reminder.type } }
    end

    assert_redirected_to update_reminder_url(UpdateReminder.last)
  end

  test "should show update_reminder" do
    get update_reminder_url(@update_reminder)
    assert_response :success
  end

  test "should get edit" do
    get edit_update_reminder_url(@update_reminder)
    assert_response :success
  end

  test "should update update_reminder" do
    patch update_reminder_url(@update_reminder), params: { update_reminder: { day_time: @update_reminder.day_time, offset: @update_reminder.offset, proportion: @update_reminder.proportion, start_end: @update_reminder.start_end, type: @update_reminder.type } }
    assert_redirected_to update_reminder_url(@update_reminder)
  end

  test "should destroy update_reminder" do
    assert_difference('UpdateReminder.count', -1) do
      delete update_reminder_url(@update_reminder)
    end

    assert_redirected_to update_reminders_url
  end
end
