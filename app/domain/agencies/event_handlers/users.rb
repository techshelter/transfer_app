module Agencies
  module EventHandlers
    class Users
      def on_users_charges_failed(event)
        payload = event[:payload]
        p payload
        Services::FailTransfer.new.call(payload[:transfer_id])
      end

      def on_users_charges_succeed(event)
        payload = event[:payload]
        Services::ProgressTransfer.new.call(payload[:transfer_id])
      end
    end
  end
end