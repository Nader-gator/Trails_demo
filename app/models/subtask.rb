class Subtask < RecordKeeper
  belongs_to(:todo,{
    primary_key: :id,
    foreign_key: :todo_id,
    class_name: "Todo"
  })
end