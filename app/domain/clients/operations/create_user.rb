module Clients
  module Operations
    class CreateUser
      include Dry::Monads[:result]
      include Deps[
        'clients.repository',
        'event_bus',
        contract: 'clients.contracts.user'
      ]

      def call(name:, number:)
        validate_input(name, number).bind do |attrs|
          create_user(**attrs)
        end
      end

      private

      def validate_input(name, number)
        result = contract.call(name: name, number: number)
        if result.success?
          Success({name: name, number: number})
        else
          Failure(result.errors.to_h)
        end
      end

      def create_user(name: ,number:)
        user_changeset = repository
                          .users
                          .changeset(:create, name: name, number: number)
                          .map(:add_timestamps)
        user = repository.create(name: name, number: number)
        if user
          event_bus.publish('users.created', payload: user)
          Success(user: user)
        else
          Failure(error: :user_not_created)
        end
      end
    end
  end
end
