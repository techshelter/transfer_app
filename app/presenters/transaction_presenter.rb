class TransactionPresenter < ApplicationPresenter
  def as_json(*)
    { 
      id: @object.id,
      user_id: @object.user_id,
      amount: @object.amount,
      transaction_type: Clients::Constant::TRANSACTION_TYPES.invert[@object.transaction_type],
      created_at: @object.created_at
    }
  end
end