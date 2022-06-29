# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table(:user_inboxes) do
      column :id, :uuid, default: Sequel.function(:uuid_generate_v4), primary_key: true
      foreign_key :user_id, :users, type: :uuid
      String :message, null: false
      String :sender, null: false

      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
