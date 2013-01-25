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

  scope :paid, where(status: "Paid")
  scope :received, where(status: "Received")
  scope :estimated, where(status: "Estimated")
  scope :invoiced, where(status: "Invoiced")

  scope :at_date, lambda { |time| where("date = ?", time) }
  scope :after_date, lambda { |time| where("date >= ?", time) }
  scope :before_date, lambda { |time| where("date <= ?", time) }

  scope :from_current_year, lambda { where("strftime('%Y', date) = ?", Time.now.strftime('%Y') ) }
  scope :from_last_year, lambda { where("strftime('%Y', date) = ?", 1.year.ago.strftime('%Y') ) }
  scope :from_current_month, lambda { where("strftime('%Y%m', date) = ?", Time.now.strftime('%Y%m') ) }
  scope :from_last_month, lambda { where("strftime('%Y%m', date) = ?", 1.month.ago.strftime('%Y%m') ) }
  scope :from_current_week, lambda { where("strftime('%W', date) = ?", Time.now.strftime('%W') ) }
  scope :from_last_week, lambda { where("strftime('%W', date) = ?", 1.week.ago.strftime('%W') ) }
  scope :from_current_day, lambda { where("strftime('%Y%m%d', date) = ?", Time.now.strftime('%Y%m%d') ) }
  scope :from_last_day, lambda { where("strftime('%Y%m%d', date) = ?", 1.day.ago.strftime('%Y%m%d') ) }

end
