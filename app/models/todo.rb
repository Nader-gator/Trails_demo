class Todo < RecordKeeper
  belongs_to(:user,{
    primary_key: :id,
    foreign_key: :user_id,
    class_name: "User"
  })
  has_many(:subtasks,{
    primary_key: :id,
    foreign_key: :todo_id,
    class_name: "Subtask"
  })
end