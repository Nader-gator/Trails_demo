class SubtasksController < ControllerBase
  def create
    if params['method'] == 'delete'
      self.delete
      return
    end
    subtask = Subtask.new(content: params["content"], todo_id: params['id'])
    subtask.save
    redirect_to('recordkeeper')
  end

  def delete
    Subtask.find(params["id"]).delete
    self.redirect_to('recordkeeper')
  end
end