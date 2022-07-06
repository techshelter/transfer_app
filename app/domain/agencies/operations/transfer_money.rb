module Agencies
  module Operations
    class TransferMoney
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)
      include Deps[
        'event_bus',
        'agencies.repository',
        transfer_contract: 'agencies.contracts.transfer',
      ]

      def call(agency_id:, sender_id:, receiver_id:, amount:)
        result = yield validate_input(sender_id, receiver_id, amount)
        transfer = yield create_transfer(**result.to_h.merge(agency_id: agency_id))
        fees = yield find_fees(agency_id)
        total_amount = yield calculate_amount(amount, fees)
        payload = {
          agency_id: agency_id,
          receiver_id: receiver_id,
          sender_id: sender_id,
          amount: amount.to_i,
          total_amount: total_amount,
          transfer_id: transfer.id,
          status: Agencies::Constant::TRANSFER_STATUSES.invert[transfer.status]
        }
        send_event(payload)
      end

      def validate_input(sender_id, receiver_id, amount)
        result = transfer_contract.call(sender_id: sender_id, receiver_id: receiver_id, amount: amount)
        if result.success?
          Success(result)
        else
          Failure(result.errors.to_h)
        end
      end

      def find_fees(agency_id)
        agency = repository.find_agency(agency_id)
        if agency
          Success(agency.fees)
        else
          Failure("Could not find agency with id #{agency_id}")
        end
      end

      def create_transfer(agency_id:, sender_id:, receiver_id:, amount:)
        transfer = repository.create_transfer(
          agency_id: agency_id,
          amount: amount,
          sender_id: sender_id,
          receiver_id: receiver_id,
        )
        Success(transfer)
      rescue => error
        Failure("Cannot create transfer #{error}")
      end

      def send_event(payload)
        event_bus.publish('agencies.transfer.requested', payload: payload)
        Success(payload)
      end

      def calculate_amount(amount, fees)
        converted_amount = amount.to_i
        total = converted_amount + (converted_amount * fees / 100)
        Success(total)
      end
    end
  end
end