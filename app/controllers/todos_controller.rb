class TodosController < ControllerBase
  def create
    todo = Todo.new(body: params["body"], title: params["title"])

    todo.save
    self.redirect_to('recordkeeper')
  end
end