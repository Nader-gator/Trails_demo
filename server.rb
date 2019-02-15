require 'rack'
require_relative 'app/controller_base/router'
require_relative 'app/controller_base/static'
require_relative 'app/controller_base/controller_base'
require_relative 'RecordKeeper/record_keeper'

# require_relative 'app/models/MODEL'
# require_relative 'app/controllers/CONTROLLER'

router = Router.new

router.draw do
  # get Regexp.new("^/PATH-HERE$"), ControllerClass, :method
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