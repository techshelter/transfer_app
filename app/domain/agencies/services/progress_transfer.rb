module Agencies
  module Services
    class ProgressTransfer
      include Deps['event_bus', 'agencies.repository']

      def call(transfer_id)
        transfer = repository.find_transfer(transfer_id)
        if transfer
          repository.progress_transfer(transfer_id)
          message = {
            sender: transfer.agency_id,
            user_id: transfer.receiver_id,
            message: "Transfer available with code #{transfer.code}"
          }
          event_bus.publish('agencies.send.message', payload: message)
        end
      end
    end
  end
end