class Track < ActiveRecord::Base
  attr_accessible :date, :status, :value

  belongs_to :expense
  has_one :label, through: :expense
  has_one :user, through: :expense

  validates :expense_id, presence: true
  validates :date, presence: true
  validates :status, presence: true
  validates :value, presence: true, numericality: { greater_than: 0 }

  default_scope order: 'tracks.created_at DESC'
end
