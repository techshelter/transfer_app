class AgencyPresenter < ApplicationPresenter
  def as_json(*)
    { 
      id: @object.id,
      name: @object.name,
      fees: @object.fees
    }
  end
end