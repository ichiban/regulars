class UsersController < ApplicationController
  skip_before_action :authenticate!, only: [:new, :create]
  before_action :set_user, only: [:destroy]

  def new
    return unless current_user
    if current_user.pages.present?
      redirect_to page_path(current_user.pages[0])
    else
      redirect_to new_page_path
    end
  end

  def create
    @user = User.where(facebook_id: user_params[:facebook_id]).first_or_initialize
    @user.access_token = user_params[:access_token]
    @user.pull
    if @user.save
      self.current_user = @user
      logout 'At least 1 facebook page or permission required' if @user.pages.empty?
    else
      logger.info @user.errors.full_messages
      head :unprocessable_entity
    end
  end

  def destroy
    if current_user == @user
      reset_session
    else
      head :unauthorized
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:facebook_id, :access_token)
  end
end
