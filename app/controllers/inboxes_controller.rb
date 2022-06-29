class InboxesController < ApplicationController
  include Dry::Monads[:result]

  def index
    user_id = params[:user_id]
    collection  = repo.user_messages(user_id)
    render json: CollectionPresenter.new(collection.to_a, presenter: MessagePresenter, key: :messages)
  end

  def create
    res =  case create_message
      in Success(message: message)
        render json: MessagePresenter.new(message)
      in Failure(errors)
        render json: {errors: errors }
    end
  end

  def show
    render json: MessagePresenter.new(find_message)
  end

  private
  def create_message
    Clients::UseCases::CreateMessage
      .new
      .call(user_id: params[:user_id], sender: params[:sender], message: params[:message])
  end

  def message_params
    params.permit(:message, :user_id, :sender)
  end

  def repo
    MyApp.instance['clients.repository']
  end

  def find_message
    repo.message_for(params[:user_id], params[:id])
  end
end
