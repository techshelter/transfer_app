module Agencies
  module Relations
    class Transactions < ROM::Relation[:sql]
      schema(:agency_transactions, infer: true) do
        associations do
          belongs_to :agency
        end
      end
    end
  end
end
