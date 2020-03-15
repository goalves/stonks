defmodule Stonks.Repo.Migrations.CreateOperators do
  use Ecto.Migration

  def change do
    create table(:operators, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string, null: false
      add :password_hash, :string, null: false

      timestamps()
    end

    create unique_index(:operators, [:email])
  end
end
