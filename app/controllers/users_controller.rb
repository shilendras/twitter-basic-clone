class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :following, :followers]

  def index
    @users = User.paginate(page: params[:page])
  end


  def show 
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create                          #Not the final implementation 
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the sample app"
      redirect_to @user

    else
      render 'new'
    end
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end



    
end

