require 'dry/system/container'
class Container < Dry::System::Container
  configure do |config|
    config.root = Rails.root

    config.component_dirs.add "app/domain"
  end
end

Container.register('persistence') do
  ROM.env
end

Container.register('event_bus') do
  APP_BUS
end

Container.finalize!

Deps = Dry::AutoInject(Container)