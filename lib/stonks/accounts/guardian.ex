defmodule Stonks.Accounts.Guardian do
  use Guardian, otp_app: :stonks

  alias Stonks.{Accounts, Validator}
  alias Stonks.Accounts.User

  @spec subject_for_token(any(), any()) :: {:ok, binary()}
  def subject_for_token(%User{id: id}, _claims) when is_binary(id) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _), do: {:error, :invalid_subject_for_token}

  @spec resource_from_claims(map()) :: {:ok, binary()} | {:error, :invalid_user_token}
  def resource_from_claims(%{"sub" => user_id}) when is_binary(user_id) do
    with :ok <- Validator.validate_uuid(user_id),
         {:ok, %User{}} <- Accounts.get_user(user_id) do
      {:ok, user_id}
    else
      _ -> {:error, :invalid_user_token}
    end
  end

  def resourece_from_claims(_), do: {:error, :invalid_user_token}
end
