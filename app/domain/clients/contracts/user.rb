module Clients
  module Contracts
    class User < Dry::Validation::Contract
      include Deps[repo: 'clients.repository']
      option :repo
      params do
        required(:name).filled(:string)
        required(:number).filled(:string)
      end

      rule(:number).validate(:numeric) do
        if values[:number].length != 10
          key.failure('should be 10 characters')
        end
        if repo.with_number_exist?(values[:number])
          key.failure('already exists')
        end
      end
    end
  end
end