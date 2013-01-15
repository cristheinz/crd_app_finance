class Label < ActiveRecord::Base
  attr_accessible :name

  has_many :expenses, foreign_key: "label_id", dependent: :destroy
  has_many :users, through: :expenses, source: :user

  before_save { self.name.downcase! }

  validates :name, presence: true, length: { maximum: 50 }, 
                    uniqueness: { case_sensitive: false }
end
