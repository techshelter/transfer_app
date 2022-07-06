module Clients
  module Services
    class ChargeUser
      include Deps['clients.repository', 'event_bus']
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call) 

      def call(number:, amount:)
        # check user balance for amount
        # take money from user
        # return success with amount and user
        user = yield check_balance(number, amount)
        charge_user(user.id, amount)
      end

      private

      def check_balance(number, amount)
        user = repository.user_by_phone_number(number)
        balance = repository.user_balance(user.id)
        return Failure({ user_id: user.id, message: "#{amount} is more than balance" }) if balance < amount
        return Success(user)
      end


      def charge_user(user_id, amount)
        transaction_changeset = repository
                                .user_transactions
                                .changeset(:create, 
                                            user_id: user_id,
                                            amount: amount,
                                            transaction_type: Constant::TRANSACTION_TYPES[:debit])
                                .map(:add_timestamps)
        transaction = repository.create(transaction_changeset)
        if transaction
          event_bus.publish('users.transactions.created', payload: transaction)
          Success(transaction: transaction)
        else
          Failure(error: :transaction_not_created)
        end
      end
    end
  end
end