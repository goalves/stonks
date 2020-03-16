defmodule Stonks.Repo.Migrations.AddDatetimeToTransactions do
  use Ecto.Migration

  import Ecto.Query

  alias Stonks.Business.Transaction
  alias Stonks.Repo

  def up do
    alter table(:transactions),
      do: add(:datetime, :utc_datetime, null: false, default: fragment("now()"))

    flush()
    query = from(transaction in Transaction, update: [set: [datetime: transaction.inserted_at]])
    Repo.update_all(query, [])
  end

  def down do
    alter table(:transactions), do: remove(:datetime)
  end
end
