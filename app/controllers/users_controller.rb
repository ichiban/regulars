class UsersController < ApplicationController
  skip_before_action :authenticate!, only: [:new, :create]
  layout 'full', only: :new

  def new
    return unless current_user
    if current_user.pages.present?
      redirect_to page_posts_path(current_user.pages[0])
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
    else
      head :unprocessable_entity
    end
  end

  def destroy
    reset_session
  end

  private

  def user_params
    params.require(:user).permit(:facebook_id, :access_token)
  end
end
