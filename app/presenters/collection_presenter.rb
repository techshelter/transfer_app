class CollectionPresenter < ApplicationPresenter
  def as_json(*)
    { 
      @key.to_sym => @object.map { |o| @presenter.new(o) }
    }
  end
end