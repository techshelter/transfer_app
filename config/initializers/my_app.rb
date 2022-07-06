
require 'dry-container'

class MyApp
  attr_reader :app, :container

  class << self
    attr_reader :instance
  end

  def self.configure
    container = Container
    yield(container)
    @instance = new(Rails.application, container)
    freeze
  end

  # def initialize(app, container)
  #   @app = app
  #   @container = container
  #   @import = Dry::AutoInject(@container)
  # end

  # def [](name)
  #   @container[name]
  # end

  # def import
  #   @import
  # end
end