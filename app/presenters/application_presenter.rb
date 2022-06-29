class ApplicationPresenter
  def initialize(object, presenter: nil, key: nil)
    @object = object
    @presenter = presenter
    @key = key || 'collection'
  end

  def as_json
    raise 'as_json called on parent.'
  end
end