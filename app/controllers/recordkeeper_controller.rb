class RecordkeeperController < ControllerBase
  def index
    @todos = {}
    Todo.all.each do |todo|
      @todos[todo] = todo.subtasks
    end
    render("index")
  end
end
