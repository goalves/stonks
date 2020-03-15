defmodule Stonks.AuthTest do
  use Stonks.DataCase, async: true

  import Stonks.Factory

  alias Ecto.UUID
  alias Faker.Internet
  alias Stonks.Auth

  describe "authenticate/2" do
    test "returns a tuple with the signed user_id and claims when password is valid" do
      password = UUID.generate()
      password_hash = Argon2.hash_pwd_salt(password)
      user = insert(:user, password_hash: password_hash)

      assert {:ok, token, _} = Auth.authenticate(user.email, password)
      assert is_binary(token)
    end

    test "returns a tuple with the signed operator_id and claims when password is valid" do
      password = UUID.generate()
      password_hash = Argon2.hash_pwd_salt(password)
      operator = insert(:operator, password_hash: password_hash)

      assert {:ok, token, _} = Auth.authenticate(operator.email, password)
      assert is_binary(token)
    end

    test "returns an error when user password is invalid" do
      password = UUID.generate()
      password_hash = Argon2.hash_pwd_salt(password)
      incorrect_password = UUID.generate()
      user = insert(:user, password_hash: password_hash)

      assert {:error, :unauthorized} == Auth.authenticate(user.email, incorrect_password)
    end

    test "returns an error when the user with the specified email does not exist" do
      email = Internet.email()
      assert {:error, :unauthorized} == Auth.authenticate(email, UUID.generate())
    end
  end
end
