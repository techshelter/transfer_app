class UsersController < ApplicationController
  include Dry::Monads[:result]

  def index
    users = operation.call
    render json: CollectionPresenter.new(users, presenter: UserPresenter, key: :users)
  end

  def create
    case create_user.call(name: user_params[:name], number: user_params[:number])
      in Success(user: user)
        render json: user
      in Failure(errors)
        render json: {errors: errors }
    end
  end

  def balance
    render json: {id: params[:id], balance: user_balance.call(params[:id])}
  end

  def credit

  end

  private
  def create_user
    Container['clients.operations.create_user']
  end
  
  def user_params
    params.permit(:name, :number)
  end

  def operation
    Container['clients.operations.list_users']
  end

  def user_balance
    Container['clients.operations.user_balance']
  end
end
