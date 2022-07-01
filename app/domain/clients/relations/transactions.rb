module Clients
  module Relations
    class Transactions < ROM::Relation[:sql]
      # TYPES = Types::String.enum('credit' => 0, 'debit' => 1)
      # INVERT_TYPES = TYPES.inverted_mapping.invert
      schema(:user_transactions, infer: true) do
        associations do
          belongs_to :user
        end
      end
    end
  end
end

# ROM.env.relations[:user_transactions]