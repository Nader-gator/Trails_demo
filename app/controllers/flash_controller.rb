class FlashController < ControllerBase
  def index
    @now = self.flash.now['message-now']
    @msg = self.flash['message']
    render('index')
  end

  def create
    messagenow = params["message-now"]
    message = params["message"]

    self.flash.now["message-now"] = messagenow
    self.flash["message"] = message
    self.index
  end
end