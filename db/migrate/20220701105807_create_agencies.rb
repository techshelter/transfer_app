# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table(:agencies) do
      column :id, :uuid, default: Sequel.function(:uuid_generate_v4), primary_key: true
      String :name, null: false
      Integer :fees, null: false

      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
