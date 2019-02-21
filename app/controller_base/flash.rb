require 'json'
require 'byebug'
class Flash
  attr_reader :now
  def initialize(req)
    @req = req
    cookie = req.cookies["_Trails_app_flash"]
    if cookie
      @now = JSON.parse(cookie)
      @cookie = JSON.parse(cookie)
    else
      @now = {}
    end
    @flash = {}
  end

  def [](key)
    @now[key.to_s] || @flash[key.to_s]
  end

  def []=(key,value)
    @flash[key.to_s] = value
  end

  def store_flash(res)
    res.set_cookie('_Trails_app_flash',value: @flash.to_json,path: @req.path)
  end

end
