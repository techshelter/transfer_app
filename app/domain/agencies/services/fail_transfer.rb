module Agencies
  module Services
    class FailTransfer
      include Deps['agencies.repository', 'event_bus']

      def call(transfer_id)
        transfer = repository.find_transfer(transfer_id)
        if transfer
          repository.fail_transfer(transfer_id)
          message = {
            sender: transfer.agency_id,
            user_id: transfer.sender_id,
            message: "Transfer available with code #{transfer.code}"
          }
          event_bus.publish('agencies.send.message', payload: message)
        end
      end
    end
  end
end