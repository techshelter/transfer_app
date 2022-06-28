class UsersController < ApplicationController
  include Dry::Monads[:result]

  def index
    render json: UsersPresenter.new(repo.all.to_a)
  end

  def create
    case create_user
      in Success(user: user)
        render json: user
      in Failure(errors)
        render json: {errors: errors }
    end
  end

  private
  def create_user
    Clients::UseCases::CreateUser
      .new
      .call(name: user_params[:name], number: user_params[:number])
  end
  
  def user_params
    params.permit(:name, :number)
  end
  
  def repo
    MyApp.instance['clients.repository']
  end


end
