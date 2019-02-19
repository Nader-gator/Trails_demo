require 'rack'
require_relative 'app/controller_base/router'
require_relative 'app/controller_base/static'
require_relative 'app/controller_base/controller_base'
require_relative 'RecordKeeper/record_keeper'

require_relative 'app/models/user'
require_relative 'app/models/todo'
require_relative 'app/models/subtask'
require_relative 'app/controllers/main_page_controller'
require_relative 'app/controllers/flash_controller'
require_relative 'app/controllers/cookies_controller'
require_relative 'app/controllers/recordkeeper_controller'
require_relative 'app/controllers/todos_controller'
require_relative 'app/controllers/subtasks_controller'
require_relative 'app/controllers/router_controller'
require_relative 'app/controllers/static_server_controller'
require_relative 'app/controllers/controller_base_controller'


# User.finalize!
# Todo.finalize!
# Subtask.finalize!


router = Router.new

router.draw do
  get Regexp.new("^/$"), MainPageController, :index
  # get Regexp.new("^/flash$"), FlashController, :index
  # post Regexp.new("^/flash$"), FlashController, :create
  # get Regexp.new("^/cookies$"), CookiesController, :index
  # post Regexp.new("^/cookies$"), CookiesController, :create
  # get Regexp.new("^/recordkeeper$"), RecordkeeperController, :index
  # post Regexp.new("^/todos$"), TodosController, :create
  # post Regexp.new("^/subtasks$"), SubtasksController, :create
  # get Regexp.new("^/router$"), RouterController, :index
  # get Regexp.new("^/static$"), StaticServerController, :index
  # get Regexp.new("^/controllerbase$"), ControllerBaseController, :index
  # get Regexp.new("^/PATH-HERE/(?<id>\\d+)$"), ControllerClass,:method
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  use Static
  run app
end.to_app

Rack::Server.start(
 app: app,
 Port: 3000
)