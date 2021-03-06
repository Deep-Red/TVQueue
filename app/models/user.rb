class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :confirmation_token
  before_save :downcase_email
  before_create :create_confirmation_digest
  after_create :send_confirmation_email

  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_insensitive: false }

  has_many :queued_episodes, foreign_key: "user_id", dependent: :destroy
  has_many :episodes, through: :queued_episodes

  # Activates an account
  def activate
    update_columns(confirmed: true, confirmed_at: Time.zone.now)
  end

  # Sends an email for the user to confirm their email address
  def send_confirmation_email
    UserMailer.email_confirmation(self).deliver_now
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if (digest.nil?)
    BCrypt::Password.new(digest).is_password?(token)
  end

  private

    # Convert email to all lower-case.
    def downcase_email
      email.downcase!
    end

    def create_confirmation_digest
      self.confirmation_token = User.new_token
      self.confirmation_digest = User.digest(confirmation_token)
    end

    # Returns the hash digest of the given string
    def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def User.new_token
      SecureRandom.urlsafe_base64
    end

end
