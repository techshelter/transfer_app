module Agencies
  module Contracts
    class Transfer < Dry::Validation::Contract
      include Deps[repo: 'agencies.repository']
      
      option :repo

      params do
        required(:sender_id).filled(:string)
        required(:receiver_id).filled(:string)
        required(:amount).value(:integer)
      end

      rule(:sender_id).validate(:numeric) do
        if values[:sender_id].length != 10
          key.failure('should be 10 characters')
        end
      end

      rule(:receiver_id).validate(:numeric) do
        if values[:receiver_id].length != 10
          key.failure('should be 10 characters')
        end
      end

      rule(:amount) do
        if values[:amount] <= 0
          key.failure('should be positif')
        end
      end
    end
  end
end