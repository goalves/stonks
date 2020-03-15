defmodule Stonks.Accounts.Guardian do
  use Guardian, otp_app: :stonks

  alias Stonks.{Accounts, Validator}
  alias Stonks.Accounts.{Operator, User}

  @spec subject_for_token(any(), any()) :: {:ok, binary()} | {:error, :invalid_subject_for_token}
  def subject_for_token(%User{id: id}, _claims) when is_binary(id), do: {:ok, id}
  def subject_for_token(%Operator{id: id}, _claims) when is_binary(id), do: {:ok, id}

  def subject_for_token(_, _), do: {:error, :invalid_subject_for_token}

  @spec resource_from_claims(map()) :: {:ok, binary()} | {:error, :invalid_token}
  def resource_from_claims(%{"sub" => user_id, "typ" => "user_access"}) when is_binary(user_id) do
    with :ok <- Validator.validate_uuid(user_id),
         {:ok, %User{}} <- Accounts.get_user(user_id) do
      {:ok, user_id}
    else
      _ -> {:error, :invalid_token}
    end
  end

  def resource_from_claims(%{"sub" => operator_id, "typ" => "operator_access"})
      when is_binary(operator_id) do
    with :ok <- Validator.validate_uuid(operator_id),
         {:ok, %Operator{}} <- Accounts.get_operator(operator_id) do
      {:ok, operator_id}
    else
      _ -> {:error, :invalid_token}
    end
  end

  def resource_from_claims(_), do: {:error, :invalid_token}
end
