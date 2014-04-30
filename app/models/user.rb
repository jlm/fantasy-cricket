class User < ActiveRecord::Base
  has_many :teams, dependent: :destroy, after_add: :update_totalscore, after_remove: :update_totalscore
  
  before_save { self.email = email.downcase }
  #before_save { validate_signup_token }
  before_create :create_remember_token
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  has_secure_password
  
  # Password validation is broken until this technique can be patched in:
  # http://www.therailsway.com/2009/8/3/users-and-passwords/
  #validates :password, length: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    def generate_token(column)
      begin
        self[column] = User.new_remember_token
      end while User.exists?(column => self[column])
    end

    def update_totalscore(t)
      $stderr.puts "+++User #{self.name} totalscore updated because a team was added to or removed from it"
      self.totalscore = self.teams.any? ? self.teams.sum(:totalscore) : 0
      self.save
    end

    def custom_update_attributes(params)
      if params[:password].blank?
        params.delete :password
        params.delete :password_confirmation
        update_attributes params
      end
    end
end
