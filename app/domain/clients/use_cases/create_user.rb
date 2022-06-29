module Clients
  module UseCases
    class CreateUser
      include Dry::Monads[:result]
      include MyApp.instance.import['clients.repository', 'clients.contracts.user_contract']
      include MyApp.instance.import['event_bus']

      def call(name:, number:)
        validate_input(name, number).bind do |attrs|
          create_user(**attrs)
        end
      end

      private

      def validate_input(name, number)
        result = user_contract.call(name: name, number: number)
        if result.success?
          Success({name: name, number: number})
        else
          Failure(result.errors.to_h)
        end
      end

      def create_user(name: ,number:)
        user_changeset = repository.users.changeset(:create, name: name, number: number)
                   .map(:add_timestamps)
        user = repository.create(user_changeset)
        if user
          event_bus.publish('users.created', user)
          Success(user: user)
        else
          Failure(error: :user_not_created)
        end
      end
    end
  end
end
