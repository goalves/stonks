defmodule Stonks.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset
  alias Stonks.Business.Transaction

  @castable_fields [:password, :name, :email]
  @required_fields [:balance, :password_hash, :name, :email]
  @create_required_fields [:balance, :password, :name, :email]
  @balance_fields [:balance]
  @default_initial_balance 100_000

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :balance, :integer, default: @default_initial_balance
    field :password, :string, virtual: true
    field :password_hash, :string
    field :name, :string
    field :email, :string

    has_many(:origin_transactions, Transaction, foreign_key: :origin_user_id)
    has_many(:destination_transactions, Transaction, foreign_key: :destination_user_id)

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map()) :: Changeset.t()
  def changeset(user = %__MODULE__{}, attributes) when is_map(attributes) do
    user
    |> cast(attributes, @castable_fields)
    |> validate_required(@required_fields)
    |> validate()
  end

  @spec create_changeset(map()) :: Changeset.t()
  def create_changeset(attributes) when is_map(attributes) do
    %__MODULE__{}
    |> cast(attributes, @castable_fields)
    |> hash_password()
    |> validate_required(@create_required_fields)
    |> validate()
  end

  @spec balance_changeset(%__MODULE__{}, integer()) :: Changeset.t()
  def balance_changeset(user = %__MODULE__{}, balance) when is_integer(balance) do
    changes = %{balance: balance}

    user
    |> cast(changes, @balance_fields)
    |> validate_required(@balance_fields)
    |> validate()
  end

  @spec validate(Changeset.t()) :: Changeset.t()
  defp validate(changeset = %Changeset{}) do
    changeset
    |> validate_number(:balance, greater_than_or_equal_to: 0)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  @spec hash_password(Changeset.t()) :: Changeset.t()
  defp hash_password(changeset = %Changeset{valid?: true, changes: %{password: password}}) do
    change(changeset, Argon2.add_hash(password))
  end

  defp hash_password(changeset = %Changeset{}), do: changeset
end
