require 'test_helper'

class ReminderSchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reminder_schedule = reminder_schedules(:one)
  end

  test "should get index" do
    get reminder_schedules_url
    assert_response :success
  end

  test "should get new" do
    get new_reminder_schedule_url
    assert_response :success
  end

  test "should create reminder_schedule" do
    assert_difference('ReminderSchedule.count') do
      post reminder_schedules_url, params: { reminder_schedule: { name: @reminder_schedule.name } }
    end

    assert_redirected_to reminder_schedule_url(ReminderSchedule.last)
  end

  test "should show reminder_schedule" do
    get reminder_schedule_url(@reminder_schedule)
    assert_response :success
  end

  test "should get edit" do
    get edit_reminder_schedule_url(@reminder_schedule)
    assert_response :success
  end

  test "should update reminder_schedule" do
    patch reminder_schedule_url(@reminder_schedule), params: { reminder_schedule: { name: @reminder_schedule.name } }
    assert_redirected_to reminder_schedule_url(@reminder_schedule)
  end

  test "should destroy reminder_schedule" do
    assert_difference('ReminderSchedule.count', -1) do
      delete reminder_schedule_url(@reminder_schedule)
    end

    assert_redirected_to reminder_schedules_url
  end
end
