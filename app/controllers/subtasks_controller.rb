class SubtasksController < ControllerBase
  def create
    subtask = Subtask.new(content: params["content"], todo_id: params['id'])
    subtask.save
    redirect_to('recordkeeper')
  end
end