class User < RecordKeeper
  has_many(:todos,{
    primary_key: :id,
    foreign_key: :user_id,
    class_name: "Todo"
  })

  has_many_through(:subtasks,:todos,:subtasks)

end