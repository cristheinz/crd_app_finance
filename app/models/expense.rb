class Expense < ActiveRecord::Base
  attr_accessible :label_id

  belongs_to :user, class_name: "User"
  belongs_to :label, class_name: "Label"
  has_many :tracks, dependent: :destroy

  validates :user_id, presence: true
  validates :label_id, presence: true

  def type
  end
  def recurrence
  end

  def payments_during(period)
    eval "tracks.paid.from_#{period}.sum(:value)"
  end
  def receipts_during(period)
    eval "tracks.received.from_#{period}.sum(:value)"
  end

  def unpaid
    v=tracks.invoiced.sum(:value)-tracks.paid.sum(:value)
    v=0 if v<=0
    v
  end

  def last_estimate
    #max_date=tracks.maximum(:date, group: :status)
    #tracks.sum(:value, 
    #    conditions: ['status = ? and date = ?',
    #      'Estimated', max_date["Estimated"]])
    max_date=tracks.estimated.maximum(:date)
    tracks.estimated.at_date(max_date).sum(:value)
  end

    #def balance(pref)
  #  rec=pref["recurrence"].downcase
  #  str="Time.now"
  #  str="1.#{rec}.ago" if pref["type"] == "Last"
  #  sum={}
  #  case 
  #  when rec=="year" && pref["type"] == "Last"
  #    sum=tracks.from_last_year.sum(:value, group: :status) 
  #  when rec=="year" && pref["type"] == "Current"
  #    sum=tracks.from_current_year.sum(:value, group: :status)
  #  #when rec=="year"
  #    #sum=tracks.sum(:value, group: :status, 
  #    #  conditions: ['strftime(\'%Y\', date) = ?',
  #    #    "#{eval(str).strftime('%Y')}"])
  #  when rec=="month"
  #    sum=tracks.sum(:value, group: :status, 
  #      conditions: ['strftime(\'%Y%m\', date) = ?',
  #        "#{eval(str).strftime('%Y%m')}"])
  #  when rec=="week"
  #    sum=tracks.sum(:value, group: :status, 
  #      conditions: ['strftime(\'%W\', date) = ?',
  #        "#{eval(str).strftime('%W')}"])
  #  when rec=="day"
  #    sum=tracks.sum(:value, group: :status, 
  #      conditions: ['strftime(\'%Y%m%d\', date) = ?',
  #        "#{eval(str).strftime('%Y%m%d')}"])
  #  end
  #  #puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  #  #puts "#{eval(str).strftime('%Y')}"
  #  #puts sum
  #  #puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  #  ((sum["Received"] ||= 0) - (sum["Paid"] ||= 0) )
  #end
  #def last_invoice
  #  max_date=tracks.invoiced.maximum(:date)
  #  tracks.invoiced.at_date(max_date).sum(:value)
  #end

end
