defmodule Stonks.Query do
  alias Ecto.Changeset

  @base_data %{}
  @spec parse_filters(map, map) :: {:ok, map} | {:error, Changeset.t()}
  def parse_filters(types, params) when is_map(types) and is_map(params) do
    types_keys = Map.keys(types)

    {@base_data, types}
    |> Changeset.cast(params, types_keys)
    |> case do
      changeset = %Changeset{valid?: true} -> {:ok, Changeset.apply_changes(changeset)}
      changeset = %Changeset{} -> {:error, changeset}
    end
  end
end
