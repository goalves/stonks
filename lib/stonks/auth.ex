defmodule Stonks.Auth do
  alias Stonks.Accounts
  alias Stonks.Accounts.{Guardian, User}

  @spec authenticate(binary(), binary()) :: {:ok, binary(), map()} | {:error, :unauthorized}
  def authenticate(email, password) when is_binary(email) and is_binary(password) do
    with {:ok, user = %User{}} <- Accounts.get_user_by_email(email),
         {:ok, _} <- Argon2.check_pass(user, password) do
      Guardian.encode_and_sign(user)
    else
      _ -> {:error, :unauthorized}
    end
  end
end
