class TodosController < ControllerBase
  def create
    if params["method"] == "delete"
      self.delete
      return
    end
    todo = Todo.new(body: params["body"], title: params["title"])

    todo.save
    self.redirect_to('recordkeeper')
  end

  def delete
    Todo.find(params["id"]).delete
    self.redirect_to('recordkeeper')
  end
end