defmodule Stonks.Validator do
  alias Ecto.UUID

  @invalid_error {:error, :invalid_uuid}

  @spec validate_uuid(any) :: :ok | {:error, :invalid_uuid}
  def validate_uuid(string) when is_binary(string) do
    case UUID.cast(string) do
      {:ok, _} -> :ok
      _ -> @invalid_error
    end
  end

  def validate_uuid(_), do: {:error, :invalid_uuid}
end
