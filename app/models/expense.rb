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

  def balance(pref)
    rec=pref["recurrence"].downcase
    str="Time.now"
    str="1.#{rec}.ago" if pref["type"] == "Last"
     
    sum={}
    case rec
    when "year"
      sum=tracks.sum(:value, group: :status, 
        conditions: ['strftime(\'%Y\', date) = ?',
          "#{eval(str).strftime('%Y')}"])
    when "month"
      sum=tracks.sum(:value, group: :status, 
        conditions: ['strftime(\'%Y%m\', date) = ?',
          "#{eval(str).strftime('%Y%m')}"])
    when "week"
      sum=tracks.sum(:value, group: :status, 
        conditions: ['strftime(\'%W\', date) = ?',
          "#{eval(str).strftime('%W')}"])
    when "day"
      sum=tracks.sum(:value, group: :status, 
        conditions: ['strftime(\'%Y%m%d\', date) = ?',
          "#{eval(str).strftime('%Y%m%d')}"])
    end

    #puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    #puts "#{eval(str).strftime('%Y')}"
    #puts sum
    #puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

    ((sum["Received"] ||= 0) - (sum["Paid"] ||= 0) )
  end

  def invoiced
    max_date=tracks.maximum(:date, group: :status)
    tracks.sum(:value, 
        conditions: ['status = ? and date = ?',
          'Invoiced', max_date["Invoiced"]])
  end

  def estimated
    max_date=tracks.maximum(:date, group: :status)
    tracks.sum(:value, 
        conditions: ['status = ? and date = ?',
          'Estimated', max_date["Estimated"]])
  end
end
