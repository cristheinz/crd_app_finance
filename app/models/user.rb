class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password

  has_many :expenses, foreign_key: "user_id", dependent: :destroy
  has_many :labels, through: :expenses, source: :label
  has_many :tracks, through: :expenses

  before_save { self.email.downcase! }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def following?(label)
    expenses.find_by_label_id(label.id)
  end

  def follow!(label)
    unless following?(label)
      expenses.create!(label_id: label.id)
    end
    following?(label)
  end

  def unfollow!(label)
    expenses.find_by_label_id(label.id).destroy
  end

  def balance
    tracks.received.sum(:value) - tracks.paid.sum(:value)
  end

  def totals_of(period)
    totals={}
    expenses.each do |e|
      totals[:unpaid]= (totals[:unpaid]||=0)+e.unpaid
      totals[:paid]= (totals[:paid]||=0)+e.payments_during(period)
      totals[:received]= (totals[:received]||=0)+e.receipts_during(period)
      totals[:estimate]= (totals[:estimate]||=0)+e.last_estimate
    end
    totals
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
