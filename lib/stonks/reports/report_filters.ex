defmodule Stonks.Backoffice.ReportFilter do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset

  @required_fields [:start_datetime]
  @fields [:end_datetime | @required_fields]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  embedded_schema do
    field :start_datetime, :utc_datetime
    field :end_datetime, :utc_datetime
  end

  def new(attributes) when is_map(attributes) do
    %__MODULE__{}
    |> changeset(attributes)
    |> case do
      changeset = %Changeset{valid?: true} -> {:ok, apply_changes(changeset)}
      changeset = %Changeset{valid?: false} -> {:error, changeset}
    end
  end

  @spec changeset(%__MODULE__{}, map()) :: Changeset.t()
  defp changeset(report_argument = %__MODULE__{}, attributes) when is_map(attributes) do
    report_argument
    |> cast(attributes, @fields)
    |> validate_required(@required_fields)
  end
end
