class TransactionsController < ApplicationController
  include Dry::Monads[:result]
  
  def index
    transactions = repo.transactions_for(params[:user_id])
    render json: CollectionPresenter.new(transactions.to_a, presenter: TransactionPresenter, key: :transactions)
  end

  def create
    res =  case create_transaction
      in Success(transaction: transaction)
        render json: TransactionPresenter.new(transaction)
      in Failure(errors)
        render json: {errors: errors }
    end
  end

  private
  def create_transaction
    Clients::UseCases::CreateTransaction
      .new
      .call(user_id: params[:user_id], amount: params[:amount].to_i)
  end

  def transaction_params
    params.permit(:message, :user_id, :amoun)
  end

  def repo
    MyApp.instance['clients_repository']
  end

end
