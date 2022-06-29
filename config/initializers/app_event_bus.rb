class AppEventBus
  include Dry::Events::Publisher[:money_transfer]

  register_event('users.created')
  register_event('users.message.created')
end