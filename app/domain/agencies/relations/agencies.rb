module Agencies
  module Relations
    class Agencies < ROM::Relation[:sql]
      schema(:agencies, infer: true) do
        associations do
          has_many :agency_transfers, as: :transfers
          has_many :agency_transactions, as: :transactions
        end
      end
    end
  end
end