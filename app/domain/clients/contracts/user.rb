module Clients
  module Contracts
    class User < Dry::Validation::Contract
      option :repo
      params do
        required(:name).filled(:string)
        required(:number).filled(:string)
      end

      rule(:number).validate(:numeric) do
        if values[:number].length != 10
          key.failure('number should be 10 characters')
        end
        if repo.with_number_exist?(values[:number])
          key.failure('user with this number already exists')
        end
      end
    end
  end
end