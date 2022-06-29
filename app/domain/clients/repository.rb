module Clients
  class Repository < ROM::Repository[:users]
    commands :create

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
  end
end