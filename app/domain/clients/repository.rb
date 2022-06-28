module Clients
  class Repository < ROM::Repository[:users]
    commands :create

    def all
      users
    end

    def exist?(number)
      !users.where(number: number).to_a.empty?
    end
  end
end