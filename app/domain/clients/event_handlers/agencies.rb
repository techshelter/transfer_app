module Clients
  module EventHandlers
    class Agencies
      include Dry::Monads[:result]

      def on_agencies_transfer_requested(event)
        payload = event[:payload]
        result = Services::ChargeUser.new.call(number: payload[:sender_id], amount: payload[:total_amount])
        case result
          in Success(_payload)
            APP_BUS.publish('users.charges.succeed', payload: {transfer_id: payload[:transfer_id]})
          in Failure(_error)
            APP_BUS.publish('users.charges.failed', payload: {transfer_id: payload[:transfer_id]})
        end
      end

      def on_agencies_send_message(event)
        payload = event[:payload]
        Services::SendMessage.new.call(**payload)
      end
    end
  end
end