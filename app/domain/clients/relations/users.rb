module Clients
  module Relations
    class Users < ROM::Relation[:sql]
      schema(:users, infer: true) do
        associations do
          has_one :user_inboxes, as: :inbox
        end
      end
    end
  end
end