module Clients
  module Relations
    class Inboxes < ROM::Relation[:sql]
      schema(:user_inboxes, infer: true) do
        associations do
          belongs_to :user
        end
      end
    end
  end
end

# ROM.env.relations[:user_inboxes]