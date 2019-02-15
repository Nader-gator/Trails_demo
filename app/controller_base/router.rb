
class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern,@http_method = pattern,http_method
    @controller_class,@action_name = controller_class,action_name
  end

  def matches?(req)
    (self.http_method == req.request_method.downcase.to_sym) && !!(self.pattern =~ req.path)
  end

  def run(req, res)
    data = @pattern.match(req.path)

    params = Hash[data.names.zip(data.captures)]
    controller = controller_class.new(req,res,params)
    controller.invoke_action(self.action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, http_method, controller_class, action_name)
    @routes << Route.new(pattern,http_method,controller_class,action_name)
  end

  def draw(&proc)
    instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern,controller_class,action_name|
      add_route(pattern,http_method,controller_class,action_name)
    end
  end

  def match(req)
    self.routes.find {|route| route.matches?(req)}
  end

  def run(req, res)
    route = match(req)
    if route.nil?
      res.status = 404
    else
      route.run(req,res)
    end

  end
end
