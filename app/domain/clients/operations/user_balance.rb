module Clients
  module Operations
    class UserBalance
      include Deps[repository: 'clients.repository']

      def call(id)
        repository.user_balance(id)
      end
    end
  end
end