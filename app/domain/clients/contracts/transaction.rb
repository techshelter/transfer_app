module Clients
  module Contracts
    class Transaction < Dry::Validation::Contract
      option :repo

      params do
        required(:user_id).filled(:string)
        required(:amount).filled(:integer)
      end

      rule(:amount) do
        if values[:amount] <= 0
          key.failure('should be more than zero')
        end
      end

      rule(:user_id) do
        if UUID.validate(values[:user_id])
          if repo.by_id(values[:user_id]).nil?
            key.failure('does not exist')
          end
        else
          key.failure('does not exist')
        end
      end
    end
  end
end