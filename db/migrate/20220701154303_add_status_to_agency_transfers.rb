# frozen_string_literal: true

ROM::SQL.migration do
  change do
    alter_table(:agency_transfers) do
      add_column :status, Integer, default: 0
    end
  end
end
