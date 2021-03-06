class UsersController < ApplicationController
  skip_before_action :authorized?, only: [:new, :create]

  def index

    @participations = Participation.all
    @user_participations = @participations.select {|participation| participation.user_id == session[:user_id]}
    
    @marathons = Marathon.all
    @marathon = Marathon.find_by(id: session[:user_id])

    @users = User.all
    @user = User.find_by(id: session[:user_id])

    #calling Donations to find all donations made by user
    @funds = Fund.all
    @donations = Donation.all
    @user_donations = @donations.select {|donation| donation.user_id == session[:user_id]}
    if @user_participations == []
      flash[:notice] = "You are currently not following any Marathons."
    end
    # @participation = !!@participations.find_by(user_id: session[:user_id])
    # if @participation == false
    #   flash[:notice] = "You're not following any marathons!"
    #   render :index
    # else
     # @user = User.find(session[:user])
    # @marathon = @participation.marathon_id
  # end
  end

  # def show
  #   @user = User.find(params[:id])
  #   @participations = Participation.all
  # end

  def new
    @user = User.new

  end

  def create
    @user = User.create(user_params)
    session[:user_id] = @user.id #added
    redirect_to profile_path
  end

  def edit
    @user = User.find_by(id: session[:user_id])
  end

  def update
    @user = User.find_by(id: session[:user_id])
    @user.update(user_params)
    redirect_to users_path
  end

  def destroy
    @user = User.find_by(id: session[:user_id])
    @user.destroy
    redirect_to login_path
  end


  def profile
    @user = User.find_by(id: session[:user_id])
    render "profile"
  end

  private
    def user_params
      params.require(:user).permit(:name, :age, :password, :password_confirmation)
    end


end
