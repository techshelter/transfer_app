module Agencies
  class Repository < ROM::Repository[:agencies]
    include Deps[container: 'persistence']

    commands :create,
      use: :timestamps,
      plugins_options: {
        timestamps: {
          timestamps: %i(created_at updated_at)
        }
      }

      commands update: :by_pk,
      use: :timestamps,
      plugins_options: {
        timestamps: {
          timestamps: %i(updated_at)
        }
      }

    def all
      agencies
    end

    def create_transfer(agency_id:, sender_id:, receiver_id:, amount:)
      code = SecureRandom.alphanumeric(8)
      changeset = agency_transfers.changeset(
        :create,
        agency_id: agency_id,
        sender_id: sender_id,
        receiver_id: receiver_id,
        amount: amount,
        code: code,
        status: Constant::TRANSFER_STATUSES[:pending]
      ).map(:add_timestamps)
      create(changeset)
    end

    def find_agency(id)
      agencies.by_pk(id).one!
    end

    def find_transfer(id)
      agency_transfers.by_pk(id).one!
    end

    def fail_transfer(id)
      command = agency_transfers.by_pk(id).command(:update)
      command.call(status: Constant::TRANSFER_STATUSES[:failed])
    end

    def progress_transfer(id)
      command = agency_transfers.by_pk(id).command(:update)
      command.call(status: Constant::TRANSFER_STATUSES[:in_progress])
    end
  end
end