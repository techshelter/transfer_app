# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table(:agency_transfers) do
      column :id, :uuid, default: Sequel.function(:uuid_generate_v4), primary_key: true
      foreign_key :agency_id, :agencies, type: :uuid
      Integer :amount, null: false
      String :to_user, null: false
      String :from_user, null: false
      String :code, null: false

      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
