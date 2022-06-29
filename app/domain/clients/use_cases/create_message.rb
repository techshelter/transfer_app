module Clients
  module UseCases
    class CreateMessage
      include Dry::Monads[:result]
      include MyApp.instance.import['clients.repository', 'clients.contracts.message_contract']
      include MyApp.instance.import['event_bus']

      def call(message: , user_id:, sender:)
        validate_input(message, user_id, sender).bind do |attrs|
          create_message_for_user(**attrs)
        end
      end
  
      private
  
      def validate_input(message, user_id, sender)
        result = message_contract.call(message: message, user_id: user_id, sender: sender)
          if result.success?
            Success({ message: message, user_id: user_id, sender: sender })
          else
            Failure(result.errors.to_h)
          end
      end
  
      def create_message_for_user(message:, user_id:, sender:)
        changeset = repository.user_inboxes.changeset(:create, message: message, user_id: user_id, sender: sender)
                              .map(:add_timestamps)
  
        message_created = repository.create(changeset)
        if message_created
          event_bus.publish('users.message.created', message_created)
          Success(message: message_created)
        else
          Failure(error: :message_not_created)
        end
      end
    end
  end
end