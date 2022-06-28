class UsersPresenter < ApplicationPresenter
  def as_json(*)
    { 
      users: @object.map { |o| UserPresenter.new(o) }
    }
  end
end