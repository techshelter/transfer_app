require Rails.root.join('app/domain/clients/event_handlers/agencies')
require Rails.root.join('app/domain/agencies/event_handlers/users')
class AppEventBus
  include Dry::Events::Publisher[:my_publisher]

  register_event('users.created')
  register_event('users.messages.created')
  register_event('users.transactions.created')
  register_event('users.charges.succeed')
  register_event('users.charges.failed')
  register_event('agencies.transfer.requested')
  register_event('agencies.send.message')
end

APP_BUS = AppEventBus.new
[
  Clients::EventHandlers::Agencies,
  Agencies::EventHandlers::Users,
].each do |handler|
  APP_BUS.subscribe(handler.new)
end