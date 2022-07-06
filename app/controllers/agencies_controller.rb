class AgenciesController < ApplicationController
  def index
    render json: CollectionPresenter.new(repo.all.to_a, presenter: AgencyPresenter, key: :agencies)
  end

  private
  def repo
    MyApp.instance['agencies_repository']
  end
end
