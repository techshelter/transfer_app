module Clients
  module Services
    class SendMessage
      include Deps['clients.repository']

      def call(sender:, user_id:, message:)
        user = repository.user_by_phone_number(user_id)
        if user
          x = {
            message: message,
            user_id: user.id,
            sender: sender
          }

          result = Operations::CreateMessage.new.call(
            message: message,
            user_id: user.id,
            sender: sender
          )
        end
      end
    end
  end
end