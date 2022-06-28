module Clients
  module Relations
    class Transactions < ROM::Relation[:sql]
      schema(:user_transactions, infer: true) do
        associations do
          belongs_to :user
        end
      end
    end
  end
end

# ROM.env.relations[:user_transactions]