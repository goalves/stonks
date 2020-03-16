defmodule Stonks.Business.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset
  alias Stonks.Accounts.User

  @required_fields [:amount, :origin_user_id, :type]
  @fields [:destination_user_id | @required_fields]
  @withdraw_type "withdraw"
  @transfer_type "transfer"
  @valid_types [@withdraw_type, @transfer_type]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :amount, :integer
    field :type, :string
    field :datetime, :utc_datetime

    belongs_to(:origin_user, User)
    belongs_to(:destination_user, User)

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map()) :: Changeset.t()
  def changeset(transaction = %__MODULE__{}, attributes) when is_map(attributes) do
    transaction
    |> cast(attributes, @fields)
    |> validate_required(@required_fields)
    |> validate()
    |> put_timestamp()
    |> assoc_constraint(:origin_user)
    |> assoc_constraint(:destination_user)
  end

  @spec validate(Changeset.t()) :: Changeset.t()
  defp validate(changeset = %Changeset{}) do
    changeset
    |> validate_number(:amount, greater_than: 0)
    |> validate_inclusion(:type, @valid_types)
    |> validate_type_for_transaction()
    |> validate_accounts()
  end

  @spec validate_type_for_transaction(Changeset.t()) :: Changeset.t()
  defp validate_type_for_transaction(changeset = %Changeset{valid?: true}) do
    changeset
    |> apply_changes()
    |> validate_transaction(changeset)
  end

  defp validate_type_for_transaction(changeset = %Changeset{}), do: changeset

  @spec validate_transaction(%__MODULE__{}, Changeset.t()) :: Changeset.t()
  defp validate_transaction(%__MODULE__{type: @withdraw_type, destination_user_id: account}, changeset = %Changeset{})
       when not is_nil(account),
       do: add_error(changeset, :destination_user, "cannot be set on withdraws")

  defp validate_transaction(%__MODULE__{type: @transfer_type, destination_user_id: account}, changeset = %Changeset{})
       when is_nil(account),
       do: add_error(changeset, :destination_user, "needs to be set on transfers")

  defp validate_transaction(_, changeset = %Changeset{}), do: changeset

  @spec validate_accounts(Changeset.t()) :: Changeset.t()
  defp validate_accounts(changeset = %Changeset{valid?: true}) do
    origin_user = get_field(changeset, :origin_user_id)
    destination_user = get_field(changeset, :destination_user_id)

    if origin_user != destination_user,
      do: changeset,
      else: add_error(changeset, :destination_user, "cannot be the same as the origin account")
  end

  defp validate_accounts(changeset = %Changeset{}), do: changeset

  @spec put_timestamp(Changeset.t()) :: Changeset.t()
  defp put_timestamp(changeset = %Changeset{valid?: true}) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    put_change(changeset, :datetime, now)
  end

  defp put_timestamp(changeset = %Changeset{}), do: changeset
end
