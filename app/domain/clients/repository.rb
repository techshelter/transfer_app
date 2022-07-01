module Clients
  class Repository < ROM::Repository[:users]
    commands :create,
      use: :timestamps,
      plugins_options: {
        timestamps: {
          timestamps: %i(created_at updated_at)
        }
      }
    
    struct_namespace Clients::Entities

    def all
      users
    end

    def with_number_exist?(number)
      !users.where(number: number).to_a.empty?
    end

    def by_id(id)
      users.by_pk(id).one
    end
    
    def user_messages(id)
      user_inboxes.where(user_id: id)
    end

    def message_for(user_id, message_id)
      user_inboxes.where(user_id: user_id, id: message_id).one!
    end

    def transactions_for(user_id)
      user_transactions.where(user_id: user_id)
    end

    def user_with_transactions(id)
      users.by_pk(id).combine(:transactions).one!
    end

    def user_balance(user_id)
      credits = user_transactions.where(user_id: user_id, transaction_type: 0)
                .to_a
                .map(&:amount)
                .sum
      debit = user_transactions.where(user_id: user_id, transaction_type: 1)
                .to_a
                .map(&:amount)
                .sum
      credits - debit
    end
  end
end