require 'BCrypt'
class User < RecordKeeper
  has_many(:todos,{
    primary_key: :id,
    foreign_key: :user_id,
    class_name: "Todo"
  })

  has_many_through(:subtasks,:todos,:subtasks)
  
  def self.find_by_credentials(name, password)
    user = User.find_by(name: name)
    return nil unless user
    return user.valid_password?(password) ? user : nil
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def valid_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  
  def reset_session_token
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64(64)
  end
end