module Clients
  module UseCases
    class CreateTransaction
      include Dry::Monads[:result]
      include MyApp.instance.import['clients.repository', 'clients.contracts.transaction_contract']
      include MyApp.instance.import['event_bus']

      def call(user_id: , amount:)
        validate_input(user_id, amount).bind do |attrs|
          create_transaction(**attrs)
        end
      end

      private

      def validate_input(user_id, amount)
        result = transaction_contract.call(user_id: user_id, amount: amount)
        if result.success?
          Success({user_id: user_id, amount: amount})
        else
          Failure(result.errors.to_h)
        end
      end

      def create_transaction(user_id: ,amount:)
        transaction_changeset = repository.user_transactions.changeset(:create, 
                                                                       user_id: user_id,
                                                                       amount: amount,
                                                                       transaction_type: Constant::TRANSACTION_TYPES['credit'])
                   .map(:add_timestamps)
        transaction = repository.create(transaction_changeset)
        if transaction
          event_bus.publish('users.transactions.created', transaction)
          Success(transaction: transaction)
        else
          Failure(error: :transaction_not_created)
        end
      end
    end
  end
end
