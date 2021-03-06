class UsersController < ApplicationController
  

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @hash = Gmaps4rails.build_markers(@users) do |user, marker|
        marker.lat user.latitude
        marker.lng user.longitude
        marker.infowindow user.description
         marker.picture({
       "url" => "http://icons.iconarchive.com/icons/thehoth/seo/32/seo-web-code-icon.png",
       "width" =>  32,
       "height" => 32})
end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @location = params[:search]
    @distance = params[:miles]
    @users = User.near(@location, @distance)

    if @location.empty?
      # gflash notice: "You can't search without a search term; please enter a location and retry!"
      redirect_to "/"
    else
      if @users.length < 1
        # gflash notice: "Sorry! We couldn't find any camps within #{@distance} miles of #{@location}."
        redirect_to "/"
      else
        # search_map(@users)
      end
    end

  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

end
