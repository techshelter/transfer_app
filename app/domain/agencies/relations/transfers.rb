module Agencies
  module Relations
    class Transfers < ROM::Relation[:sql]
      schema(:agency_transfers, infer: true) do
        associations do
          belongs_to :agency
        end
      end
    end
  end
end
