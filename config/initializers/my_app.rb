# require Rails.root.join('config/initializers/event_bus')
# require Rails.root.join('app/domain/clients/repository')
# Dir[Rails.root.join('app/domain/clients/contracts/*.rb')].each {|file| require file }

MyApp.configure do |container|
  container.register('persistence') do
    ROM.env
  end

  container.register('event_bus') do 
    AppEventBus.new
  end
  
  container.register('clients.repository') do
    Clients::Repository.new(container['persistence'])
  end
  container.register('clients.contracts.user_contract') do
    Clients::Contracts::User.new(
      repo: container['clients.repository']
    )
  end

  container.register('clients.contracts.message_contract') do
    Clients::Contracts::Message.new(
      repo: container['clients.repository']
    )
  end

  container.register('clients.contracts.transaction_contract') do
    Clients::Contracts::Transaction.new(
      repo: container['clients.repository']
    )
  end
end