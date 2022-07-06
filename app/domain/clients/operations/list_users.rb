module Clients
  module Operations
    class ListUsers
      include Deps['clients.repository']

      def call
        repository.users.to_a
      end
    end
  end
end