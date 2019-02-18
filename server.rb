require 'rack'
require_relative 'app/controller_base/router'
require_relative 'app/controller_base/static'
require_relative 'app/controller_base/controller_base'
require_relative 'RecordKeeper/record_keeper'

require_relative 'app/models/user'
require_relative 'app/models/todo'
require_relative 'app/models/subtask'
require_relative 'app/controllers/users_controller'
require_relative 'app/controllers/todos_controller'
require_relative 'app/controllers/subtasks_controller'
require_relative 'app/controllers/sessions_controller'


User.finalize!
Todo.finalize!
Subtask.finalize!


# router = Router.new

# router.draw do
#   get Regexp.new("^/$"), SessionsController, :index
#   post Regexp.new("^/$"), SessionsController, :create
#   delete Regexp.new("^/$"), SessionsController, :destroy
#   # get Regexp.new("^/PATH-HERE/(?<id>\\d+)$"), ControllerClass,:method
# end

# app = Proc.new do |env|
#   req = Rack::Request.new(env)
#   res = Rack::Response.new
#   router.run(req, res)
#   res.finish
# end

# app = Rack::Builder.new do
#   use Static
#   run app
# end.to_app

# Rack::Server.start(
#  app: app,
#  Port: 3000
# )