require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:one)
  end

  test "should get index" do
    get tasks_url
    assert_response :success
  end

  test "should get new" do
    get new_task_url
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post tasks_url, params: { task: { completed_flag: @task.completed_flag, duration: @task.duration, end_date: @task.end_date, job_id: @task.job_id, linked_flag: @task.linked_flag, name: @task.name, offset: @task.offset, percentage_completed: @task.percentage_completed, start_date: @task.start_date, start_end_flag: @task.start_end_flag, task_id: @task.task_id } }
    end

    assert_redirected_to task_url(Task.last)
  end

  test "should show task" do
    get task_url(@task)
    assert_response :success
  end

  test "should get edit" do
    get edit_task_url(@task)
    assert_response :success
  end

  test "should update task" do
    patch task_url(@task), params: { task: { completed_flag: @task.completed_flag, duration: @task.duration, end_date: @task.end_date, job_id: @task.job_id, linked_flag: @task.linked_flag, name: @task.name, offset: @task.offset, percentage_completed: @task.percentage_completed, start_date: @task.start_date, start_end_flag: @task.start_end_flag, task_id: @task.task_id } }
    assert_redirected_to task_url(@task)
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete task_url(@task)
    end

    assert_redirected_to tasks_url
  end
end
