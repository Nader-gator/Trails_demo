require 'json'

class Session

  def initialize(req)
    @req = req
    cookie = req.cookies['_Trails_app']

    if cookie
      @cookie_data = JSON.parse(cookie)
    else
      @cookie_data = {}
    end
  end

  def [](key)
    @cookie_data[key]
  end

  def []=(key, val)
    @cookie_data[key]=val
  end

  def store_session(res)
    cookie = {path: @req.path,
      value: @cookie_data.to_json,expire_after: Time.now+24*60*60*14}
    res.set_cookie('_Trails_app',cookie)
  end
end
