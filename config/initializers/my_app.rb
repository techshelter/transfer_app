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
  container.register('clients.contracts.new_user') do
    Clients::Contracts::NewUser.new(
      repo: container['clients.repository']
    )
  end
end