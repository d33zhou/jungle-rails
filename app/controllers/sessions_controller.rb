class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if user = User.authenticate_with_credentials(params[:email], params[:password])
      session[:user_id] = user.id
      redirect_to '/', notice: 'Signed in!'
    else
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end
end
