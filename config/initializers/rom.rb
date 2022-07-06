ROM::Rails::Railtie.configure do |config|
  config.gateways[:default] = [:sql, ENV.fetch('DATABASE_URL')]
  config.auto_registration_paths += [Rails.root.join('app/domain/clients/')]
  config.auto_registration_paths += [Rails.root.join('app/domain/agencies/')]
end