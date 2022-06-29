class MessagePresenter < ApplicationPresenter
  def as_json(*)
    { 
      id: @object.id,
      message: @object.message,
      user_id: @object.user_id,
      sender: @object.sender
    }
  end
end