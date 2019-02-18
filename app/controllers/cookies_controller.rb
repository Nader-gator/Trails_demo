class CookiesController < ControllerBase
  def index
    @msg = self.session['cookie-msg'] || []
    render('index')
  end

  def create
    self.session['cookie-msg'] ||= []
    self.session['cookie-msg']<< params['cookie-msg']
    self.index
  end
end