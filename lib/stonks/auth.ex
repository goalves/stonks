defmodule Stonks.Auth do
  alias Stonks.Accounts
  alias Stonks.Accounts.{Guardian, Operator, User}

  @spec authenticate(binary(), binary()) :: {:ok, binary(), map()} | {:error, :unauthorized}
  def authenticate(email, password) when is_binary(email) and is_binary(password) do
    with {:ok, user_or_operator} <- fetch_user_or_operator(email),
         {:ok, _} <- Argon2.check_pass(user_or_operator, password) do
      encode_and_sign(user_or_operator)
    else
      _ -> {:error, :unauthorized}
    end
  end

  defp fetch_user_or_operator(email) when is_binary(email) do
    {_, user} = Accounts.get_user_by_email(email)
    {_, operator} = Accounts.get_operator_by_email(email)

    case {user, operator} do
      {%User{}, _} -> {:ok, user}
      {_, %Operator{}} -> {:ok, operator}
      _ -> {:error, :user_or_operator_does_not_exist}
    end
  end

  defp encode_and_sign(user = %User{}), do: Guardian.encode_and_sign(user, %{}, token_type: "user_access")

  defp encode_and_sign(operator = %Operator{}),
    do: Guardian.encode_and_sign(operator, %{}, token_type: "operator_access")
end
