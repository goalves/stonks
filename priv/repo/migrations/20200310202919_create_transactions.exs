defmodule Stonks.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :amount, :bigint, null: false
      add :origin_user, references(:users, type: :binary_id), null: false
      add :type, :string, null: false
      add :destination_user, references(:users, type: :binary_id)

      timestamps()
    end
  end
end
