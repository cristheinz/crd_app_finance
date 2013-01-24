module ExpensesHelper
  def recurrence_fraction
    f=1
    case session[:prefs]["recurrence"].downcase
    when "year"
      f=1
    when "month"
      f=12
    when "week"
      f=54
    when "day"
      f=365
    end
  end

  def balance_totals
  	tracks=current_user.tracks
  	rec=session[:prefs]["recurrence"].downcase
    str="Time.now"
    str="1.#{rec}.ago" if session[:prefs]["type"] == "Last"
     
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
    ((sum["Received"] ||= 0) - (sum["Paid"] ||= 0) )
  end
end