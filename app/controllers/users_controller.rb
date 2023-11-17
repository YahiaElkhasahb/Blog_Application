class UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      render json: { token: @user.generate_token }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      render json: { token: @user.generate_token }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
