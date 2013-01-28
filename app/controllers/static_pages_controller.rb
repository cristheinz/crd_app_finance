class StaticPagesController < ApplicationController
  def home
  	if signed_in?
      store_location
  		#track_form
  		@labels = Label.find(:all,:select=>'name').map(&:name)
  		@label = Label.new
	  	@track = Track.new

	  	#lists
  		@tracks = current_user.tracks.paginate(page: params[:page], per_page: 6)

  		#info
  		#p=current_user.tracks.sum(:value, conditions: ['status = ?','Paid'])
  		#r=current_user.tracks.sum(:value, conditions: ['status = ?','Received'])
  		#@balance = r-p
  	end
  	
  end
end
