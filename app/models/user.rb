class User < ActiveRecord::Base
  has_many :teams, dependent: :destroy, after_add: :update_totalscore, after_remove: :update_totalscore
  
  before_save { self.email = email.downcase }
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

  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    def update_totalscore(t)
      $stderr.puts "+++Team #{t.name} added/removed to/from user #{self.name}"
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
