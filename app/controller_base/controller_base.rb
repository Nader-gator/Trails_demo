require 'active_support/inflector'
require 'erb'
require 'active_support' 
require 'active_support/core_ext'
require_relative './session'
require_relative './flash'

class ControllerBase
  attr_reader :req, :res, :params,:session
  attr_accessor :response_built

  def initialize(req, res,params = {})
    @req, @res = req, res
    @response_built = false
    @params = params.merge(req.params)
  end

  def already_built_response?
    @response_built
  end

  def redirect_response_prep
    raise "Double render error" if self.already_built_response?
    self.response_built = true
    self.session.store_session(@res)

  end

  def redirect_to(url)
    self.redirect_response_prep
    @res.status = 302
    @res["Location"] = url
  end

  def render_content(content, content_type)
      self.redirect_response_prep
      @res.write(content)
      @res['Content-Type'] = content_type

    nil
  end

  def render(template_name)
    path = File.dirname(__FILE__)
    template_path = File.join(path,"..",'views',self.class.name.underscore,"#{template_name}.html.erb")
    template = File.read(template_path)
    render_content(ERB.new(template).result(binding),"text/html")
  end

  def session
    @session ||= Session.new(@req)
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless already_built_response?
  end

  def flash
    @flash ||= Flash.new(@req)
  end
  
  def controller_name
    self.class.to_s.underscore
  end
end

