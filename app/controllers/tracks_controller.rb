class TracksController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user,   only: :destroy

  def create
  	@labels = Label.find(:all,:select=>'name').map(&:name)
    @tracks = current_user.tracks.paginate(page: params[:page], per_page: 6)

  	@track = Track.new
  	@label = Label.find_by_name(params[:label][:name])
  	if @label.nil?
  		@label = Label.new(params[:label])
  		if @label.save
  			@expense = current_user.follow!(@label)
  			@track = @expense.tracks.build(params[:track])
  			if @track.save
  				#flash[:success] = "Expense tracked!"
  				redirect_to root_path
  			else
  				render 'static_pages/home'
  			end
  		else
  			render 'static_pages/home'
  		end
  	else
  		@expense = current_user.follow!(@label)
  		@track = @expense.tracks.build(params[:track])
  		if @track.save
  			#flash[:success] = "Expense tracked!"
  			redirect_to root_path
  		else
  			render 'static_pages/home'
  		end
  	end
  	
  end

  def destroy
  	@track.destroy
    #redirect_to root_url
    redirect_back_or root_url
  end

  private

    def correct_user
      @track = current_user.tracks.find_by_id(params[:id])
      redirect_to root_url if @track.nil?
    end
end