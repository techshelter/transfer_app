class UsersController < ApplicationController
  include Dry::Monads[:result]

  def index
    render json: CollectionPresenter.new(repo.all.to_a, presenter: UserPresenter, key: :users)
  end

  def create
    case create_user
      in Success(user: user)
        render json: user
      in Failure(errors)
        render json: {errors: errors }
    end
  end

  def balance
    render json: {id: params[:id], balance: repo.user_balance(params[:id])}
  end

  def credit

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
