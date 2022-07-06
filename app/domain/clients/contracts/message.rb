module Clients
  module Contracts
    class Message < Dry::Validation::Contract
      include Deps[repo: 'clients.repository']

      option :repo

      params do
        required(:user_id).filled(:string)
        required(:message).filled(:string)
        required(:sender).filled(:string)
      end

      rule(:sender) do
        if !UUID.validate(values[:sender])
          key.failure('does not exist')
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