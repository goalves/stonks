defmodule Stonks.Accounts.Operator do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset

  @castable_fields [:password, :email]
  @required_fields [:password_hash, :email]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "operators" do
    field :password, :string, virtual: true
    field :password_hash, :string
    field :email, :string

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map()) :: Changeset.t()
  def changeset(operator = %__MODULE__{}, attributes) when is_map(attributes) do
    operator
    |> cast(attributes, @castable_fields)
    |> hash_password()
    |> validate_required(@required_fields)
    |> validate()
  end

  @spec validate(Changeset.t()) :: Changeset.t()
  defp validate(changeset = %Changeset{}) do
    changeset
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  @spec hash_password(Changeset.t()) :: Changeset.t()
  defp hash_password(changeset = %Changeset{valid?: true, changes: %{password: password}}) do
    change(changeset, Argon2.add_hash(password))
  end

  defp hash_password(changeset = %Changeset{}), do: changeset
end
