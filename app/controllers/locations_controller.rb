class LocationsController < ApplicationController
	def index
		if params[:search].present?
			@users = User.near(params[:search], 1, :order => :distance)
		else
			@users = User.all
		end
	end

	def show
		@user = User.find(params[:id])

		#sets up hash for map marker
		@hash = Gmaps4rails.build_markers(@user) do |user, marker|
		  marker.lat user.latitude
		  marker.lng user.longitude
		  marker.infowindow "<a target='blank' href='https://www.google.com/maps/place/"+"#{user.address}"+"'>Get Directions With Google Maps</a>"
		  marker.json({ title: user.name })
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			redirect_to space @user, :notice => "Successfully created location"
		else
			render :action => 'new'
		end
	end

	def search
		@location = params[:search]
		@distance = params[:miles]
		@users = User.near(@location, @distance)

		if @location.empty?
			gflash notice: "You can't search without a search term; please enter a location and retry!"
			redirect_to "/"
		else
			if @users.length < 1
				gflash notice: "Sorry! We couldn't find any camps within #{@distance} miles of #{@location}."
				redirect_to "/"
			else
				search_map(@users)
			end
		end

	end
	
private
	# sets up the map hash for gmaps4rails
	def search_map(users)
		@users = users
		@hash = Gmaps4rails.build_markers(@users) do |user, marker|
			  marker.lat user.latitude
			  marker.lng user.longitude
			  marker.infowindow "<a href='/users/"+"#{user.id}"+"'>#{user.name}, #{user.address}</a>"
			  marker.json({ title: user.name, id: user.id })
			end
		end

end
