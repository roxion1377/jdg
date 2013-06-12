require 'test_helper'

class ContestTasksControllerTest < ActionController::TestCase
  setup do
    @contest_task = contest_tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contest_tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contest_task" do
    assert_difference('ContestTask.count') do
      post :create, contest_task: { contest_id: @contest_task.contest_id, key: @contest_task.key, serial: @contest_task.serial, task_id: @contest_task.task_id }
    end

    assert_redirected_to contest_task_path(assigns(:contest_task))
  end

  test "should show contest_task" do
    get :show, id: @contest_task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contest_task
    assert_response :success
  end

  test "should update contest_task" do
    put :update, id: @contest_task, contest_task: { contest_id: @contest_task.contest_id, key: @contest_task.key, serial: @contest_task.serial, task_id: @contest_task.task_id }
    assert_redirected_to contest_task_path(assigns(:contest_task))
  end

  test "should destroy contest_task" do
    assert_difference('ContestTask.count', -1) do
      delete :destroy, id: @contest_task
    end

    assert_redirected_to contest_tasks_path
  end
end
