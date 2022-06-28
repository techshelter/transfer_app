class UserPresenter < ApplicationPresenter
  def as_json(*)
    { 
      id: @object.id,
      name: @object.name,
      number: @object.number
    }
  end
end