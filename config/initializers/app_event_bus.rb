class AppEventBus
  include Dry::Events::Publisher[:money_transfer]

  register_event('users.created')
  register_event('users.messages.created')
  register_event('users.transactions.created')
end