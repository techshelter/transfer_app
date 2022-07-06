class TransfersController < ApplicationController
  include Dry::Monads[:result]

  def create
    case operation.call(
      agency_id: transfer_params[:agency_id],
      receiver_id: transfer_params[:receiver_id],
      sender_id: transfer_params[:sender_id],
      amount: transfer_params[:amount]
    )
      in Success(payload)
        render json: {message: 'transfer initiated'}.merge(payload)
      in Failure(errors)
        render json: {errors: errors }
    end
  end

  private

  def operation
    Container['agencies.operations.transfer_money']
  end
  
  def transfer_params
    params.permit(:agency_id, :sender_id, :receiver_id, :amount)
  end
end
